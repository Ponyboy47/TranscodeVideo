import Foundation

public protocol ArgumentKey {
    var stringValue: String { get }
}

extension ArgumentKey where Self: RawRepresentable, Self.RawValue == String {
    public var stringValue: String { return rawValue }
}

extension ArgumentKey {
    var argumentName: String {
        guard stringValue.count > 1 else {
            return "-\(stringValue)"
        }
        return "--\(stringValue)"
    }
}

public protocol Optionable {
    associatedtype ArgumentKeys: ArgumentKey
    typealias Options = OptionEncoder<ArgumentKeys>

    func encode(to options: Options)
}

public final class OptionEncoder<Key: ArgumentKey> {
    private var options: [(ArgumentKey, String?)] = []

    init() {}

    func convert() -> [String] {
        return options.map { (name, value) in
            if let val = value {
                return "\(name.argumentName)=\(val)" 
            }

            return name.argumentName
        }
    }

    public func encode<T: StringRepresentable>(_ argument: T?, forKey key: Key) {
        guard let argument = argument else { return }
        options.append((key, argument.toString()))
    }

    public func encode<T: StringRepresentable>(_ arguments: [T], forKey key: Key) {
        for argument in arguments {
            options.append((key, argument.toString()))
        }
    }

    public func encode(_ argument: Bool, forKey key: Key) {
        guard argument else { return }
        options.append((key, nil))
    }
}
