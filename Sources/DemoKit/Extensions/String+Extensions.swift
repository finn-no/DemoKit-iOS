import Foundation

/// Found here:
/// https://stackoverflow.com/a/50202999
extension String {
    var titleCase: String {
        replacingOccurrences(
            of: "([A-Z])",
            with: " $1",
            options: .regularExpression,
            range: range(of: self)
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .capitalized
    }

    var capitalizingFirstLetter: String {
        prefix(1).uppercased() + dropFirst()
    }
}

