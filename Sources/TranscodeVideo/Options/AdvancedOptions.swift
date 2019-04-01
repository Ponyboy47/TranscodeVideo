/// Options aimed at advanced usage through direct interaction with the underlying commands and encoders
public struct AdvancedOptions: Optionable {
    /// Pass video encoder option by name with value or disable use of option by prefixing name with "_"
    public var encoder: [KeyValueOption]
    /// Pass `HandBrakeCLI` option by name or by name with value or disable use of option by prefixing name with "_"
    public var handbrake: [KeyValueOption]

    /**
     - Parameters:
       - encoder: Pass video encoder option by name with value or disable use of option by prefixing name with "_"
                  (e.g.: `-E vbv-bufsize=8000`)
                  (e.g.: `-E _crf-max`)
       - handbrake: Pass `HandBrakeCLI` option by name or by name with value or disable use of option by prefixing name
                          with "_"
                          (e.g.: `-H stop-at=duration:30`)
                          (e.g.: `-H _markers`)
                          (refer to `HandBrakeCLI --help` for more information)
                          (some options are not allowed)
     */
    public init(encoder: [KeyValueOption], handbrake: [KeyValueOption]) {
        self.encoder = encoder
        self.handbrake = handbrake
    }

    enum ArgumentKeys: String, ArgumentKey {
        case encoder = "encoder-option"
        case handbrake = "handbrake-option"
    }

    func encode(to options: Options) {
        options.encode(encoder, forKey: .encoder)
        options.encode(handbrake, forKey: .handbrake)
    }
}

/// Options that use a key value format of key=value
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
