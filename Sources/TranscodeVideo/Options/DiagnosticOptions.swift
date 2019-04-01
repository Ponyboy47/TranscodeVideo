/// Options related to diagnostic reporting
public struct DiagnosticOptions: Optionable {
    /// Set the level of diagnostic information to be reported
    public var diagnostics: Diagnostics?

    /**
     - Parameter diagnostics: Set the level of diagnostic information to be reported
                              (verbose or quiet)
     */
    public init(_ diagnostics: Diagnostics? = nil) {
        self.diagnostics = diagnostics
    }

    enum ArgumentKeys: String, ArgumentKey {
        case verbose
        case quiet
    }

    func encode(to options: Options) {
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
