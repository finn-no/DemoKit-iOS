import Foundation

/// Provides info for list presentation for a demo within a `DemoGroup`.
@MainActor
public protocol DemoGroupItem {
    /// Title to present for this demo when listing a `DemoGroup`.
    var groupItemTitle: String { get }
}

// MARK: - Default values

/// Default value when `DemoGroupItem` implements `RawRepresentable<String>`, i.e. an enum.
public extension DemoGroupItem where Self: RawRepresentable, RawValue == String {
    var groupItemTitle: String {
        rawValue.capitalizingFirstLetter
    }
}
