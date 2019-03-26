public struct DiagnosticOptions: Optionable {
    public var diagnostics: Diagnostics?

    public init(_ diagnostics: Diagnostics? = nil) {
        self.diagnostics = diagnostics
    }

    public enum ArgumentKeys: String, ArgumentKey {
        case verbose
        case quiet
    }

    public func encode(to options: Options) {
        guard let diagnostics = self.diagnostics else { return }

        switch diagnostics {
        case .verbose: options.encode(true, forKey: .verbose)
        case .quiet: options.encode(true, forKey: .quiet)
        }
    }
}

public enum Diagnostics: String {
    case verbose
    case quiet
}
