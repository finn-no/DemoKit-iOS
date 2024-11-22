import Foundation

/// Represents a specific tweak/configuration/setup for a `TweakableDemo`.
@MainActor
public protocol TweakingOption {
    /// The identifier for this tweak.
    /// The last tweak selection will be saved to `UserDefaults` so a re-run of the demo app will present the last viewed demo, with the last selected tweak.
    var identifier: String { get }

    /// A title for this tweak that'll be presented within the list of tweaks for a `TweakableDemo`.
    var title: String { get }
}

// MARK: - Default values

/// Default values when `TweakingOption` implements `RawRepresentable<String>`, i.e. an enum.
public extension TweakingOption where Self: RawRepresentable, RawValue == String {
    var identifier: String {
        rawValue
    }

    var title: String {
        rawValue.presentationCase
    }
}
