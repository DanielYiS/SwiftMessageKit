// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Album
  internal static let btnAlbum = L10n.tr("Localizable", "btnAlbum")
  /// Camera
  internal static let btnCamera = L10n.tr("Localizable", "btnCamera")
  /// Cancel
  internal static let btnCancel = L10n.tr("Localizable", "btnCancel")
  /// Continue
  internal static let btnContinue = L10n.tr("Localizable", "btnContinue")
  /// Recording failed
  internal static let errorRecording = L10n.tr("Localizable", "errorRecording")
  /// Result data error
  internal static let errorResultData = L10n.tr("Localizable", "errorResultData")
  /// Waiting...
  internal static let hudLabelText = L10n.tr("Localizable", "hudLabelText")
  /// Input message...
  internal static let inputMessagePlaceholder = L10n.tr("Localizable", "inputMessagePlaceholder")
  /// Release your finger to cancel sending
  internal static let messageFingerCancelSend = L10n.tr("Localizable", "messageFingerCancelSend")
  /// You have a picture message
  internal static let messageisaPicture = L10n.tr("Localizable", "messageisaPicture")
  /// You have a voice message
  internal static let messageisaVoice = L10n.tr("Localizable", "messageisaVoice")
  /// Please go to Settings -> Privacy -> Allow to access the microphone
  internal static let messageMicrophoneDesc = L10n.tr("Localizable", "messageMicrophoneDesc")
  /// Failed to initialize recording function
  internal static let messageMicrophoneReloadError = L10n.tr("Localizable", "messageMicrophoneReloadError")
  /// Can't access your microphone
  internal static let messageMicrophoneTitle = L10n.tr("Localizable", "messageMicrophoneTitle")
  /// Recording failed, please try again later
  internal static let messageRecordError = L10n.tr("Localizable", "messageRecordError")
  /// The recording time is too short
  internal static let messageRecordTimeShort = L10n.tr("Localizable", "messageRecordTimeShort")
  /// Release and send the voice message
  internal static let messageReleaseSendMessage = L10n.tr("Localizable", "messageReleaseSendMessage")
  /// Swipe up to cancel sending
  internal static let messageSwipeCancelSend = L10n.tr("Localizable", "messageSwipeCancelSend")
  /// Voice
  internal static let voice = L10n.tr("Localizable", "Voice")
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
