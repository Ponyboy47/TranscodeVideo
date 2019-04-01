/// A type which has a command line representation
protocol ArgumentKey {
    var stringValue: String { get }
}

/// Generate automatic conformance for ArgumentKey's when possible
extension ArgumentKey where Self: RawRepresentable, Self.RawValue == String {
    var stringValue: String { return rawValue }
}

extension ArgumentKey {
    /// Generates the command line representation of the argument
    var argumentName: String {
        guard stringValue.count > 1 else {
            return "-\(stringValue)"
        }
        return "--\(stringValue)"
    }
}

/// A type which supports several command line options and can be encoded into
/// a single command line representation containing all of its options
protocol Optionable {
    /// The keys used to store the arguments
    associatedtype ArgumentKeys: ArgumentKey
    /// The Encoder type which generates all the command line arguments for the current type
    typealias Options = OptionEncoder<ArgumentKeys>

    /// Encodes the arguments into the Options
    func encode(to options: Options)
}

extension Optionable {
    /// Generate all the option's arguments
    func buildOptions() -> [String] {
        let options = Options()
        encode(to: options)
        return options.convert()
    }
}

/// An encoder which turns a series of options into a single command line
/// representation of all those options
final class OptionEncoder<Key: ArgumentKey> {
    /// The set of options which have been encoded
    private var options: [(ArgumentKey, String?)] = []

    init() {}

    /// Turn the encoded options into an array of string values which may be
    /// used on the command line
    fileprivate func convert() -> [String] {
        return options.map { name, value in
            if let val = value {
                return "\(name.argumentName)=\(val)"
            }

            return name.argumentName
        }
    }

    /// Encodes a simple StringRepresentable argument
    func encode<T: StringRepresentable>(_ argument: T?, forKey key: Key) {
        guard let argument = argument else { return }
        options.append((key, argument.toString()))
    }

    /// Encodes a simple StringRepresentable argument
    func encode<T: StringRepresentable>(_ argument: T?, inherent: T? = nil, forKey key: Key) where T: Equatable {
        guard argument != inherent else { return }
        guard let argument = argument else { return }
        options.append((key, argument.toString()))
    }

    /// Encodes an array of StringRepresentable arguments
    func encode<T: StringRepresentable>(_ arguments: [T], forKey key: Key) {
        for argument in arguments {
            options.append((key, argument.toString()))
        }
    }

    /// Encode a boolean argument
    func encode(_ argument: Bool, inherent: Bool = false, forKey key: Key) {
        guard argument != inherent else { return }
        options.append((key, nil))
    }
}
