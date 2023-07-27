import Foundation

struct State {
    @UserDefault(key: "demokit.selectedGroupIndex")
    static var selectedGroupIndex: Int?

    @UserDefault(key: "demokit.selectedDemoableIndex")
    static var selectedDemoableIndex: Int?

    @UserDefault(key: "demokit.selectedTweakIndex")
    static var selectedTweakIndex: Int?

    private init() {}
}
