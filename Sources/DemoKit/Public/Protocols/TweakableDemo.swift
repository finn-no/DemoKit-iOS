import Foundation

/// A demo that is tweakable.
public protocol TweakableDemo: Demoable {
    var numberOfTweaks: Int { get }

    func tweak(for index: Int) -> any TweakingOption
    func configure(forTweakAt index: Int)
}
