import Foundation

/// Represents a specific tweak/configuration/setup for a `TweakableDemo`.
public protocol TweakingOption {
    var identifier: String { get }
    var title: String { get }
}

// MARK: - Default values

public extension TweakingOption where Self: RawRepresentable, RawValue == String {
    var identifier: String {
        rawValue
    }

    var title: String {
        rawValue.titleCase
    }
}
