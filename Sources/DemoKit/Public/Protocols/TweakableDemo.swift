import Foundation

/// A demo that is tweakable. Make your `Demoable` conform to this protocol if you want to demo multiple presentations/configurations of your demo.
///
/// Tweakable demos will get a floating button presented in the corner of the demo that presents a list of tweaks for that specific demo.
///
/// Tweaks can be useful if you have a view that can change appearance/layout dependending on the way the view is configured.
@MainActor
public protocol TweakableDemo: Demoable {
    /// The number of tweaks your demo provides.
    var numberOfTweaks: Int { get }
    /// If `true` all tweaks will be tested when snapshot tests are run.
    var shouldSnapshotTweaks: Bool { get }
    
    /// Get a tweak for a specified index.
    /// - Parameter index: The index for the tweak. Will always be between `0 ..< numberOfTweaks`.
    /// - Returns: A `TweakingOption`.
    func tweak(for index: Int) -> any TweakingOption

    
    /// Use this method to reconfigure your view according a specific tweak.
    ///
    /// This method will be called when the user selects a different tweak from your list of tweaks, or when the demo app is run again.
    /// When the demo app is run again this method will be called with the last tweak the user selected before the app was re-run.
    /// - Parameter index: The index for the tweak. Will always be between `0 ..< numberOfTweaks`.
    func configure(forTweakAt index: Int)
}

// MARK: - Default values

public extension TweakableDemo {
    var shouldSnapshotTweaks: Bool { true }
}
