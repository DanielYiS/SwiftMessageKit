// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Album
  internal static let buttonAlbum = L10n.tr("Localizable", "ButtonAlbum")
  /// Camera
  internal static let buttonCamera = L10n.tr("Localizable", "ButtonCamera")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Continue
  internal static let `continue` = L10n.tr("Localizable", "continue")
  /// The device does not support the camera
  internal static let errorProfileCameraNotDevice = L10n.tr("Localizable", "ErrorProfileCameraNotDevice")
  /// Recording failed
  internal static let errorRecording = L10n.tr("Localizable", "errorRecording")
  /// Result data error
  internal static let errorResultData = L10n.tr("Localizable", "errorResultData")
  /// Waiting...
  internal static let hudLabelText = L10n.tr("Localizable", "hudLabelText")
  /// Hold to record
  internal static let messageAudioButtonText = L10n.tr("Localizable", "MessageAudioButtonText")
  /// Text message cannot exceed 100 characters
  internal static let messageContentMaxlength = L10n.tr("Localizable", "MessageContentMaxlength")
  /// Release your finger to cancel sending
  internal static let messageFingerCancelSend = L10n.tr("Localizable", "MessageFingerCancelSend")
  /// Type something...
  internal static let messageInputPlaceholder = L10n.tr("Localizable", "MessageInputPlaceholder")
  /// You have new messages
  internal static let messageisanewmessage = L10n.tr("Localizable", "Messageisanewmessage")
  /// You have a picture message
  internal static let messageisaPicture = L10n.tr("Localizable", "MessageisaPicture")
  /// You have a voice message
  internal static let messageisaVoice = L10n.tr("Localizable", "MessageisaVoice")
  /// Please go to Settings -> Privacy -> Allow to access the microphone
  internal static let messageMicrophoneDesc = L10n.tr("Localizable", "MessageMicrophoneDesc")
  /// Failed to initialize recording function
  internal static let messageMicrophoneReloadError = L10n.tr("Localizable", "MessageMicrophoneReloadError")
  /// Can't access your microphone
  internal static let messageMicrophoneTitle = L10n.tr("Localizable", "MessageMicrophoneTitle")
  /// Recharged
  internal static let messageRecharged = L10n.tr("Localizable", "MessageRecharged")
  /// Recording failed, please try again later
  internal static let messageRecordError = L10n.tr("Localizable", "MessageRecordError")
  /// The recording time is too short
  internal static let messageRecordTimeShort = L10n.tr("Localizable", "MessageRecordTimeShort")
  /// Release and send the voice message
  internal static let messageReleaseSendMessage = L10n.tr("Localizable", "MessageReleaseSendMessage")
  /// Sending message needs 20 diamonds
  internal static let messagesendcoinsneeds = L10n.tr("Localizable", "Messagesendcoinsneeds")
  /// Logout successfully
  internal static let messageSettingLogout = L10n.tr("Localizable", "MessageSettingLogout")
  /// Swipe up to cancel sending
  internal static let messageSwipeCancelSend = L10n.tr("Localizable", "MessageSwipeCancelSend")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
