import struct TrailBlazer.FilePath
import struct TrailBlazer.GenericPath

public struct OutputOptions: Optionable {
    public let output: GenericPath
    public let format: Format
    public let chapterNames: FilePath?
    public let noLog: Bool
    public let dryRun: Bool

    public enum Format {
        case mkv
        case mp4
        case m4v
    }

    public init(output: GenericPath, format: Format = .mkv, chapterNames: FilePath?, noLog: Bool = false, dryRun: Bool = false) throws {
        self.output = try output.expanded()
        self.format = format
        self.chapterNames = try chapterNames?.expanded()
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
        options.encode(output.string, forKey: .output)
        switch format {
        case .mp4: options.encode(true, forKey: .mp4)
        case .m4v: options.encode(true, forKey: .m4v)
        default: break
        }
        options.encode(chapterNames?.string, forKey: .chapterNames)
        options.encode(noLog, forKey: .noLog)
        options.encode(dryRun, forKey: .dryRun)
    }
}
