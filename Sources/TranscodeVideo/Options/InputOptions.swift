import struct TrailBlazer.FilePath

public struct InputOptions: Optionable {
    public let source: FilePath
    public let scan: Bool
    public let title: Int?
    public let chapters: ChapterRange?

    public enum ArgumentKeys: String, ArgumentKey {
        case scan
        case title
        case chapters
    }

    public init(source: FilePath, scan: Bool = false, title: Int? = nil, chapters: ChapterRange? = nil) {
        self.source = source
        self.scan = scan
        self.title = title
        self.chapters = chapters
    }

    public func encode(to options: Options) {
        options.encode(scan, forKey: .scan)
        options.encode(title, forKey: .title)
        options.encode(chapters, forKey: .chapters)
    }
}

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
