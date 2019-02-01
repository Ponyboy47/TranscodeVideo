import struct TrailBlazer.FilePath
import struct TrailBlazer.GenericPath

public struct OutputOptions: Optionable {
    public var output: GenericPath?
    public var format: Format
    public var chapterNames: FilePath?
    public var noLog: Bool
    public var dryRun: Bool

    public enum Format {
        case mkv
        case mp4
        case m4v
    }

    public init(output: GenericPath? = nil, format: Format = .mkv, chapterNames: FilePath?, noLog: Bool = false, dryRun: Bool = false) {
        self.output = output
        self.format = format
        self.chapterNames = chapterNames
        self.noLog = noLog
        self.dryRun = dryRun
    }

    public enum ArgumentKeys: String, ArgumentKey {
        case output
        case mp4
        case m4v
        case chapterNames = "chapter-names"
        case noLog = "no-log"
        case dryRun = "dry-run"
    }

    public func encode(to options: Options) {
        options.encode(output, forKey: .output)
        switch format {
        case .mp4: options.encode(true, forKey: .mp4)
        case .m4v: options.encode(true, forKey: .m4v)
        default: break
        }
        options.encode(chapterNames, forKey: .chapterNames)
        options.encode(noLog, forKey: .noLog)
        options.encode(dryRun, forKey: .dryRun)
    }
}
