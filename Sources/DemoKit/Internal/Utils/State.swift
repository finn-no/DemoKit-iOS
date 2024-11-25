import Foundation

/// State representation for last selected group, demo and tweak.
///
/// When the user views a demo using `DemoKitViewController` we will store these values to `UserDefaults`. When the demo app is re-run we use these values to
/// be able to navigate back to the same group, view and tweak.
struct State {
    @UserDefault(key: "demokit.selectedGroupIndex")
    static var selectedGroupIndex: Int?

    @UserDefault(key: "demokit.selectedDemoableIndex")
    static var selectedDemoableIndex: Int?

    @UserDefault(key: "demokit.selectedTweakIndex")
    static var selectedTweakIndex: Int?

    private init() {}
}
