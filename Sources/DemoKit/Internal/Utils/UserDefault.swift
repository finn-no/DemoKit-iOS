import Foundation

/// Credit: https://stackoverflow.com/a/58317876
@propertyWrapper
struct UserDefault<Value> {
    private let key: String
    private let defaultValue: Value
    private let userDefaults: UserDefaults

    init(key: String, defaultValue: Value, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: Value {
        get {
            (userDefaults.object(forKey: key) as? Value) ?? defaultValue
        }
        set {
            if let nillable = newValue as? Nillable, nillable.isNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

extension UserDefault where Value: ExpressibleByNilLiteral {
    init(key: String, userDefaults: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, userDefaults: userDefaults)
    }
}

// MARK: - Protocols / extensions

protocol Nillable {
    var isNil: Bool { get }
}

extension Optional: Nillable {
    var isNil: Bool {
        self == nil
    }
}
