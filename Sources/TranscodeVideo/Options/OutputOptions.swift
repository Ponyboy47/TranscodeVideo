import struct TrailBlazer.DirectoryPath
import struct TrailBlazer.FilePath
import struct TrailBlazer.GenericPath
import protocol TrailBlazer.Path

/// Path types which may be used as an output path
public protocol OutputPath: Path {}
extension FilePath: OutputPath {}
extension DirectoryPath: OutputPath {}

public let outputDefaults = (format: OutputOptions.Format.mkv, noLog: false, dryRun: false)

/// Options related to the output of the transcoded media
public struct OutputOptions: Optionable {
    /// Set output path and filename, or just path
    public var output: GenericPath?
    /// The output media container
    public var format: Format
    /// Import chapter names from `.csv` text file
    public var chapterNames: FilePath?
    /// Don't write log file
    public var noLog: Bool
    /// Don't transcode, just show `HandBrakeCLI` command and exit
    public var dryRun: Bool

    public enum Format: String {
        case mkv
        case mp4
        case m4v
    }

    /**
     - Parameters:
       - output: Set output path and filename, or just path
                 (default: input filename with output format extension in current working directory)
       - format: The output media container
                 (mkv, mp4, or m4v)
                 (default: mkv)
       - chapterNames: Import chapter names from `.csv` text file
                       (in NUMBER,NAME format, e.g. "1,Intro")
       - noLog: Don't write log file
       - dryRun: Don't transcode, just show `HandBrakeCLI` command and exit
     */
    public init<PathType: OutputPath>(output: PathType? = nil, format: Format = outputDefaults.format,
                                      chapterNames: FilePath?, noLog: Bool = outputDefaults.noLog,
                                      dryRun: Bool = outputDefaults.dryRun) {
        if let path = output {
            self.output = GenericPath(path.absolute ?? path)
        }
        self.format = format
        self.chapterNames = chapterNames
        self.noLog = noLog
        self.dryRun = dryRun
    }

    enum ArgumentKeys: String, ArgumentKey {
        case output
        case mp4
        case m4v
        case chapterNames = "chapter-names"
        case noLog = "no-log"
        case dryRun = "dry-run"
    }

    func encode(to options: Options) {
        options.encode(output, forKey: .output)
        switch format {
        case .mp4: options.encode(true, forKey: .mp4)
        case .m4v: options.encode(true, forKey: .m4v)
        default: break
        }
        options.encode(chapterNames, forKey: .chapterNames)
        options.encode(noLog, inherent: outputDefaults.noLog, forKey: .noLog)
        options.encode(dryRun, inherent: outputDefaults.dryRun, forKey: .dryRun)
    }
}
