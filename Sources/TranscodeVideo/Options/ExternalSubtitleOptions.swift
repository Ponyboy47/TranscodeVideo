import struct TrailBlazer.FilePath

public struct ExternalSubtitleOptions: Optionable {
    public var burnSRT: FilePath
    public var forced: [AddedSubtitle]
    public var add: [AddedSubtitle]

    public init(burnSRT: FilePath, forced: [AddedSubtitle] = [], add: [AddedSubtitle] = []) {
        self.burnSRT = burnSRT
        self.forced = forced
        self.add = add
    }

    public enum ArgumentKeys: String, ArgumentKey {
        case burnSRT = "burn-srt"
        case forceSRT = "force-srt"
        case addSRT = "add-srt"
        case bindSRTLanguage = "bind-srt-language"
        case bindSRTEncoding = "bind-srt-encoding"
        case bindSRTOffset = "bind-srt-offset"
    }

    public func encode(to options: Options) {
        options.encode(burnSRT, forKey: .burnSRT)
        for subtitle in forced {
            options.encode(subtitle.file, forKey: .forceSRT)
            options.encode(subtitle.language, forKey: .bindSRTLanguage)
            options.encode(subtitle.format, forKey: .bindSRTEncoding)
            options.encode(subtitle.offset, forKey: .bindSRTOffset)
        }
        for subtitle in add {
            options.encode(subtitle.file, forKey: .forceSRT)
            options.encode(subtitle.language, forKey: .bindSRTLanguage)
            options.encode(subtitle.format, forKey: .bindSRTEncoding)
            options.encode(subtitle.offset, forKey: .bindSRTOffset)
        }
    }
}

public struct AddedSubtitle {
    fileprivate var file: FilePath
    fileprivate var language: String?
    fileprivate var format: String?
    fileprivate var offset: Int?

    public init(file: FilePath, language: String? = nil, format: String? = nil, offset: Int? = nil) {
        self.file = file
        self.language = language
        self.format = format
        self.offset = offset
    }
}
