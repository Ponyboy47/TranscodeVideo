import struct TrailBlazer.DirectoryPath
import struct TrailBlazer.FilePath
import struct TrailBlazer.GenericPath
import protocol TrailBlazer.Path

public protocol OutputPath: Path {}
extension FilePath: OutputPath {}
extension DirectoryPath: OutputPath {}

public struct OutputOptions: Optionable {
    public var output: GenericPath?
    public var format: Format
    public var chapterNames: FilePath?
    public var noLog: Bool
    public var dryRun: Bool

    public enum Format: String {
        case mkv
        case mp4
        case m4v
    }

    public init<PathType: OutputPath>(output: PathType? = nil, format: Format = .mkv, chapterNames: FilePath?,
                                      noLog: Bool = false, dryRun: Bool = false) {
        if let path = output {
            self.output = GenericPath(path.absolute ?? path)
        }
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
