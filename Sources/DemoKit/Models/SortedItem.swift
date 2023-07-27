import Foundation

/// An item that can be sorted and holds a reference to the original item's index.
struct SortedItem {
    let originalIndex: Int
    let title: String
}

extension [SortedItem] {
    func sortByTitle() -> [SortedItem] {
        sorted(by: { $0.title < $1.title })
    }
}
