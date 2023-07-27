import Foundation

extension String {
    /// Credit: https://stackoverflow.com/a/50202999
    /// Formats a `camelCase` or `PascalCase` string into a `Camel Case`/`Pascal Case`.
    public var presentationCase: String {
        replacingOccurrences(
            of: "([A-Z])",
            with: " $1",
            options: .regularExpression,
            range: range(of: self)
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .capitalized
    }

    public var capitalizingFirstLetter: String {
        prefix(1).uppercased() + dropFirst()
    }
}

