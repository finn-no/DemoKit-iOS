import Foundation

/// Defines how a `Demoable` can be dismissed. There are some default values that will handle it for you, or you can choose to implement something yourself.
public enum DismissKind {
    /// Adds a button to the bottom of the view controller presenting the demo, that dismisses it.
    case button
    /// Double tap anywhere in the view to dismiss it.
    case doubleTap
    /// No default dismissal handling. This forces you to handle dismissal yourself, i.e. by using a button within the navbar or something else.
    case none
}
