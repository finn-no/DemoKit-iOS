# DemoKit

A library for making smooth demo apps.

## But how?

I'll tell you how!

Have the views you want to demo conform to `Demoable`:
```swift
extension AwesomeViewController: Demoable {
    var title: String {
        "Awesome!"
    }

    var dismissKind: DismissKind {
        .button // Overlays a button to dismiss the view
    }
}
```

Add the views to a `DemoGroup`:
```swift
enum ViewsDemoGroup: String, CaseIterable, DemoGroup, DemoGroupItem {
    case awesomeView
    case superbView

    static var groupTitle: String {
        "Views"
    }

    static var numberOfDemos: Int {
        allCases.count
    }

    static func demoGroupItem(for index: Int) -> DemoKit.DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> DemoKit.Demoable {
        switch allCases[index] {
        case .awesomeView:
            AwesomeViewController()
        case .superbView:
            SuperbViewController()
        }
    }
}
```

Create and display a `DemoKitViewController` with your demo groups, for example in SceneDelegate:
```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let demoKitViewController = DemoKitViewController.init(demoGroups: [
            ViewsDemoGroup.self
        ])
        let rootViewController = UINavigationController(rootViewController: demoKitViewController)

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }

    // [...]
}
```
