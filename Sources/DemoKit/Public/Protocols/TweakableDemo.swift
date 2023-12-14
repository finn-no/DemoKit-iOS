import Foundation

/// A demo that is tweakable.
@MainActor
public protocol TweakableDemo: Demoable {
    var numberOfTweaks: Int { get }
    var shouldSnapshotTweaks: Bool { get }

    func tweak(for index: Int) -> any TweakingOption
    func configure(forTweakAt index: Int)
}

public extension TweakableDemo {
    var shouldSnapshotTweaks: Bool { true }
}
