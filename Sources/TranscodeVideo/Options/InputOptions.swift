public struct InputOptions: Optionable {
    public var scan: Bool
    public var title: Int?
    public var chapters: ChapterRange?

    public enum ArgumentKeys: String, ArgumentKey {
        case scan
        case title
        case chapters
    }

    public init(scan: Bool = false, title: Int? = nil, chapters: ChapterRange? = nil) {
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
