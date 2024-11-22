import Foundation

/// An item that can be sorted and holds a reference to the original item's index.
///
/// Used i.e. when getting the list of demos, which might be unsorted, but sorted alphabetically for presentation.
struct SortedItem {
    let originalIndex: Int
    let title: String
}

extension [SortedItem] {
    func sortByTitle() -> [SortedItem] {
        sorted(by: { $0.title < $1.title })
    }
}
