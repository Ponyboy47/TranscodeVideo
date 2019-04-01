public let inputDefaults = (scan: false, unusedButRequired: false)

/// Options related to the input media and determining which title or part of
/// the title to transcode
public struct InputOptions: Optionable {
    /// List title(s) and tracks in video media and exit
    public var scan: Bool
    /// Select indexed title in video media
    public var title: Int?
    /// Select chapters, single or range
    public var chapters: ChapterRange?

    enum ArgumentKeys: String, ArgumentKey {
        case scan
        case title
        case chapters
    }

    /**
     - Parameters:
       - scan: List title(s) and tracks in video media and exit
       - title: Select indexed title in video media
                (default: main feature or first listed)
       - chapters: Select chapters, single or range
                   (default: all)
     */
    public init(scan: Bool = inputDefaults.scan, title: Int? = nil, chapters: ChapterRange? = nil) {
        self.scan = scan
        self.title = title
        self.chapters = chapters
    }

    func encode(to options: Options) {
        options.encode(scan, inherent: inputDefaults.scan, forKey: .scan)
        options.encode(title, forKey: .title)
        options.encode(chapters, forKey: .chapters)
    }
}

/// Represent either a single chapter or a range of chapters in a media track
public struct ChapterRange: ExpressibleByIntegerLiteral, StringRepresentable {
    public let stringValue: String

    public init(start: Int, end: Int) {
        stringValue = "\(start)-\(end)"
    }

    public init(_ chapter: Int) {
        self.init(integerLiteral: chapter)
    }

    public init(integerLiteral value: Int) {
        stringValue = "\(value)"
    }
}
