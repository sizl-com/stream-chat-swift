//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

// MARK: - Protocol

/// Describes an object that can record audio
public protocol AudioRecording {
    /// A static function which returns an instance of the type conforming to `AudioRecording`
    init()

    /// Subscribes the provided object on AudioRecorder's updates
    func subscribe(_ subscriber: AudioRecordingDelegate)

    /// Begin the recording process and calls the completionHandler once all the permission requests
    /// have been answered.
    /// - Parameter completionHandler: The completionHandler to call once the recording has
    /// started successfully *only*. In the case of an error the completionHandler won't be called and the
    /// delegate will be informed of the error in the `didFail` method.
    /// - Note: If the recording permission has been answered before
    /// the completionHandler will be called immediately, otherwise it will be called once the user has
    /// replied on the request permission prompt.
    func beginRecording(_ completionHandler: @escaping (() -> Void))

    /// Pause the currently active recording process
    func pauseRecording()

    /// Resume a paused recording process
    func resumeRecording()

    /// Stop a recording process
    func stopRecording()
}

// MARK: - Implementation

/// Definition of a class to handle audio recording
open class StreamAudioRecorder: AudioRecording {

    public private(set) var subscribeWasCalledWithSubscriber: AudioRecordingDelegate?
    public private(set) var beginRecordingWasCalledWithCompletionHandler: (() -> Void)?
    public private(set) var pauseRecordingWasCalled: Bool = false
    public private(set) var resumeRecordingWasCalled: Bool = false
    public private(set) var stopRecordingWasCalled: Bool = false

    public required init() {}

    public func subscribe(_ subscriber: AudioRecordingDelegate) {
        subscribeWasCalledWithSubscriber = subscriber
    }

    public func beginRecording(_ completionHandler: @escaping (() -> Void)) {
        beginRecordingWasCalledWithCompletionHandler = completionHandler
    }

    public func pauseRecording() {
        pauseRecordingWasCalled = true
    }

    public func resumeRecording() {
        resumeRecordingWasCalled = true
    }

    public func stopRecording() {
        stopRecordingWasCalled = true
    }
}

// MARK: - Error

/// An enum that acts as a namespace for various audio recording errors that might occur
public class AudioRecorderError: ClientError {
    /// An unknown error occurred
    public static func unknown(file: StaticString = #file, line: UInt = #line) -> AudioRecorderError { .init("An unknown error occurred.", file, line) }

    /// User has not granted permission to record audio
    public static func noRecordPermission(file: StaticString = #file, line: UInt = #line) -> AudioRecorderError { .init("Missing permission to record.", file, line) }

    /// Failed to begin audio recording
    public static func failedToBegin(file: StaticString = #file, line: UInt = #line) -> AudioRecorderError { .init("Failed to begin recording.", file, line) }

    /// Failed to resume audio recording
    public static func failedToResume(file: StaticString = #file, line: UInt = #line) -> AudioRecorderError { .init("Failed to resume recording.", file, line) }

    /// Failed to save audio recording
    public static func failedToSave(file: StaticString = #file, line: UInt = #line) -> AudioRecorderError { .init("Failed to save recording.", file, line) }
}
