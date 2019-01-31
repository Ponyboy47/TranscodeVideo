public struct AdvancedOptions: Optionable {
    public let encoder: [KeyValueOption]
    public let handbrake: [KeyValueOption]

    public init(encoder: [KeyValueOption], handbrake: [KeyValueOption]) {
        self.encoder = encoder
        self.handbrake = handbrake
    }

    public enum ArgumentKeys: String, ArgumentKey {
        case encoder = "encoder-option"
        case handbrake = "handbrake-option"
    }

    public func encode(to options: Options) {
        options.encode(encoder, forKey: .encoder)
        options.encode(handbrake, forKey: .handbrake)
    }
}

public struct KeyValueOption: StringRepresentable {
    public let stringValue: String

    public init<T: StringRepresentable>(name: String, value: T?) {
        if let val = value {
            stringValue = "\(name)=\(val.toString())"
        } else {
            stringValue = name
        }
    }
}
