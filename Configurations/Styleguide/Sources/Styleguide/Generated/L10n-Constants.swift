// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  /// E-Mail
  public static let email = L10n.tr("Localization", "email", fallback: "E-Mail")
  /// Login
  public static let login = L10n.tr("Localization", "login", fallback: "Login")
  /// Logge dich mit deinen RoomieRadar Anmeldedaten ein.
  public static let loginScreenMainText = L10n.tr("Localization", "login_screen_main_text", fallback: "Logge dich mit deinen RoomieRadar Anmeldedaten ein.")
  /// Passwort
  public static let password = L10n.tr("Localization", "password", fallback: "Passwort")
  /// Registrieren
  public static let register = L10n.tr("Localization", "register", fallback: "Registrieren")
  /// Du hast noch keinen Account? Registriere dich jetzt und finde genau, wonach du suchst!
  public static let registerScreenMainText = L10n.tr("Localization", "register_screen_main_text", fallback: "Du hast noch keinen Account? Registriere dich jetzt und finde genau, wonach du suchst!")
  /// RoomieRadar
  public static let roomieRadar = L10n.tr("Localization", "roomie_radar", fallback: "RoomieRadar")
  /// Wonach suchst du?
  public static let searchingQuestion = L10n.tr("Localization", "searching_question", fallback: "Wonach suchst du?")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
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
