// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Button {
    /// Close
    internal static let close = L10n.tr("Localizable", "button.close")
  }

  internal enum Charts {
    /// No data
    internal static let nodata = L10n.tr("Localizable", "charts.nodata")
  }

  internal enum Label {
    /// All time
    internal static let all = L10n.tr("Localizable", "label.all")
    /// Today
    internal static let day = L10n.tr("Localizable", "label.day")
    /// DOWN
    internal static let down = L10n.tr("Localizable", "label.down")
    /// High
    internal static let high = L10n.tr("Localizable", "label.high")
    /// Low
    internal static let low = L10n.tr("Localizable", "label.low")
    /// Past month
    internal static let month = L10n.tr("Localizable", "label.month")
    /// Past 3 months
    internal static let quarter = L10n.tr("Localizable", "label.quarter")
    /// UP
    internal static let up = L10n.tr("Localizable", "label.up")
    /// Past week
    internal static let week = L10n.tr("Localizable", "label.week")
    /// Past year
    internal static let year = L10n.tr("Localizable", "label.year")
  }

  internal enum Market {
    /// Cryptocurrencies
    internal static let cryptocurrencies = L10n.tr("Localizable", "market.cryptocurrencies")
    /// Forex
    internal static let forex = L10n.tr("Localizable", "market.forex")
    /// Stocks
    internal static let stocks = L10n.tr("Localizable", "market.stocks")
    /// Portfolio
    internal static let today = L10n.tr("Localizable", "market.today")
  }

  internal enum Period {
    /// ALL
    internal static let all = L10n.tr("Localizable", "period.all")
    /// 1D
    internal static let day = L10n.tr("Localizable", "period.day")
    /// 1M
    internal static let month = L10n.tr("Localizable", "period.month")
    /// 3M
    internal static let quarter = L10n.tr("Localizable", "period.quarter")
    /// 1W
    internal static let week = L10n.tr("Localizable", "period.week")
    /// 1Y
    internal static let year = L10n.tr("Localizable", "period.year")
  }

  internal enum Portfolio {
    /// My Portfolio
    internal static let my = L10n.tr("Localizable", "portfolio.my")
    /// My Watchlist
    internal static let watch = L10n.tr("Localizable", "portfolio.watch")
  }

  internal enum Search {
    /// Search
    internal static let placeholder = L10n.tr("Localizable", "search.placeholder")
  }

  internal enum Tab {
    /// Market
    internal static let market = L10n.tr("Localizable", "tab.market")
    /// Portfolio
    internal static let portfolio = L10n.tr("Localizable", "tab.portfolio")
    /// Search
    internal static let search = L10n.tr("Localizable", "tab.search")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
