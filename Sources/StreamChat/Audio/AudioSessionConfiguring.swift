//
// Copyright © 2023 Stream.io Inc. All rights reserved.
//

import AVFoundation

// MARK: - Protocol

/// A protocol describing an object that can configure/interact with `AVAudioSession`
protocol AudioSessionConfiguring {
    /// The required initialiser
    init()

    /// Calling this method should activate the provided `AVAudioSession` for recording.
    func activateRecordingSession() throws

    /// Calling this method should deactivate recording from the provided `AVAudioSession`.
    func deactivateRecordingSession() throws

    /// Calling this method should activate the provided `AVAudioSession` for playback.
    func activatePlaybackSession() throws

    /// Calling this method should deactivate playback from the provided `AVAudioSession`.
    func deactivatePlaybackSession() throws

    /// Calling this method should go through iOS to get or request permission to record and once provided
    /// with a result, call the completionHandler to continue the flow.
    /// - Parameter completionHandler: The completion handler that will be called to continue the flow.
    func requestRecordPermission(
        _ completionHandler: @escaping (Bool) -> Void
    )
}

// MARK: - Implementation

/// An implementation where for macOS we don't have interactions with AVAudioSession as it's not available.
final class StreamAudioSessionConfigurator: AudioSessionConfiguring {
    func activateRecordingSession() throws { /* No-op */ }

    func deactivateRecordingSession() throws { /* No-op */ }

    func activatePlaybackSession() throws { /* No-op */ }

    func deactivatePlaybackSession() throws { /* No-op */ }

    func requestRecordPermission(_ completionHandler: @escaping (Bool) -> Void) { completionHandler(true) }
}

// MARK: - Errors

final class AudioSessionConfiguratorError: ClientError {
    /// An unknown error occurred
    static func noAvailableInputsFound(
        file: StaticString = #file,
        line: UInt = #line
    ) -> AudioSessionConfiguratorError {
        .init("No available audio inputs found.", file, line)
    }
}
