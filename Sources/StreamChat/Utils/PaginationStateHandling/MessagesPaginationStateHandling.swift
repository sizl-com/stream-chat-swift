//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import Foundation

/// A component responsible for handling the messages pagination state.
protocol MessagesPaginationStateHandling {
    /// The current state of the messages pagination.
    var state: MessagesPaginationState { get }

    /// This function should be called before performing the pagination call.
    func start(pagination: MessagesPagination)
    /// This function should be called with the result of the pagination call.
    func end(pagination: MessagesPagination, with result: Result<[MessagePayload], Error>)
}

/// A component responsible for handling the messages pagination state.
class MessagesPaginationStateHandler: MessagesPaginationStateHandling {
    var state: MessagesPaginationState = .initial

    func start(pagination: MessagesPagination) {
        // When loading a page around a message we set isJumpingToMessage to true
        // And only when we finish loading all the next messages, we set it back to false
        if pagination.parameter?.isJumpingToMessage == true {
            state.isJumpingToMessage = true
        }

        switch pagination.parameter {
        case .lessThan, .lessThanOrEqual:
            state.isLoadingPreviousMessages = true

        case .greaterThan, .greaterThanOrEqual:
            state.isLoadingNextMessages = true

        case .around:
            state.isLoadingMiddleMessages = true

        case .none:
            state.hasLoadedAllPreviousMessages = false
            state.isLoadingPreviousMessages = false
            state.isLoadingMiddleMessages = false
            state.isLoadingNextMessages = false
            state.oldestFetchedMessage = nil
            state.newestFetchedMessage = nil
            state.isJumpingToMessage = false
        }
    }

    func end(pagination: MessagesPagination, with result: Result<[MessagePayload], Error>) {
        state.isLoadingNextMessages = false
        state.isLoadingMiddleMessages = false
        state.isLoadingPreviousMessages = false

        guard let messages = result.value else {
            return
        }

        let oldestFetchedMessage = messages.first
        let newestFetchedMessage = messages.last
        
        switch pagination.parameter {
        case .lessThan, .lessThanOrEqual:
            state.oldestFetchedMessage = oldestFetchedMessage
            if messages.count < pagination.pageSize {
                state.hasLoadedAllPreviousMessages = true
            }

        case .greaterThan, .greaterThanOrEqual:
            state.newestFetchedMessage = newestFetchedMessage
            if messages.count < pagination.pageSize {
                state.newestFetchedMessage = nil
                state.isJumpingToMessage = false
            }

        case .around:
            state.oldestFetchedMessage = oldestFetchedMessage
            state.newestFetchedMessage = newestFetchedMessage
            if messages.count < pagination.pageSize {
                state.isJumpingToMessage = false
                state.hasLoadedAllPreviousMessages = true
            }

        case .none:
            state.oldestFetchedMessage = oldestFetchedMessage
            state.newestFetchedMessage = nil
            if messages.count < pagination.pageSize {
                state.isJumpingToMessage = false
                state.hasLoadedAllPreviousMessages = true
            }
        }

        if let aroundMessageId = pagination.parameter?.aroundMessageId {
            calculateHasLoadedAllMessagesBasedOnTheLocation(of: aroundMessageId, given: messages)
        }
    }

    /// If we are jumping to a message we can determine if we loaded the oldest page
    /// or the newest page, depending on where the aroundMessageId is located.
    /// - If the aroundMessageId is in the middle of the messages response,
    ///   it means there are still older and newer pages to fetch.
    /// - If the aroundMessageId is on first half of the messages response,
    ///   it means we loaded all the oldest pages
    /// - If the aroundMessageId is on the second half of the messages response,
    ///   it means we loaded all the newest pages
    private func calculateHasLoadedAllMessagesBasedOnTheLocation(of aroundMessageId: MessageId, given messages: [MessagePayload]) {
        guard !messages.isEmpty else {
            return
        }

        let midIndex = messages.count / 2
        let midPoint: Int = Int(floor(Double(midIndex)))
        let secondHalf = messages[midPoint...].dropFirst()

        // If the message is in the mid point, it means there's more pages to load in both sides
        if messages[midPoint].id == aroundMessageId {
            state.isJumpingToMessage = true
            // If the message is in the second half of the response, it means there are no more next messages,
            // so it means jumping is finished.
        } else if secondHalf.contains(where: { $0.id == aroundMessageId }) {
            state.isJumpingToMessage = false
            // Otherwise, if the message is on the first half, it means it loaded all previous messages.
            // If the messages was not found, it could also mean we are jumping to a parent message.
        } else {
            state.hasLoadedAllPreviousMessages = true
        }
    }
}
