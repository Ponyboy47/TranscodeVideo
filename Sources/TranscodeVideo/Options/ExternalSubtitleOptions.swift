import struct TrailBlazer.FilePath

/// Options relating to the inclusion of external subtitles into the transcoded media
public struct ExternalSubtitleOptions: Optionable {
    /// Burn SubRip-format text file into video
    public var burnSRT: FilePath
    /// Add subtitle track from SubRip-format text file and set forced flag
    public var forced: [ExternalSubtitle]
    /// Add subtitle track from SubRip-format text file
    public var add: [ExternalSubtitle]

    /**
     - Parameters:
       - burnSRT: Burn SubRip-format text file into video
       - forced: Add subtitle track from SubRip-format text file and set forced flag
       - add: Add subtitle track from SubRip-format text file
     */
    public init(burnSRT: FilePath, forced: [ExternalSubtitle] = [], add: [ExternalSubtitle] = []) {
        self.burnSRT = burnSRT
        self.forced = forced
        self.add = add
    }

    enum ArgumentKeys: String, ArgumentKey {
        case burnSRT = "burn-srt"
        case forceSRT = "force-srt"
        case addSRT = "add-srt"
        case bindSRTLanguage = "bind-srt-language"
        case bindSRTEncoding = "bind-srt-encoding"
        case bindSRTOffset = "bind-srt-offset"
    }

    func encode(to options: Options) {
        options.encode(burnSRT, forKey: .burnSRT)
        for subtitle in forced {
            options.encode(subtitle.file, forKey: .forceSRT)
            options.encode(subtitle.language, inherent: externalSubtitleDefaults.language, forKey: .bindSRTLanguage)
            options.encode(subtitle.format, inherent: externalSubtitleDefaults.format, forKey: .bindSRTEncoding)
            options.encode(subtitle.offset, inherent: externalSubtitleDefaults.offset, forKey: .bindSRTOffset)
        }
        for subtitle in add {
            options.encode(subtitle.file, forKey: .addSRT)
            options.encode(subtitle.language, inherent: externalSubtitleDefaults.language, forKey: .bindSRTLanguage)
            options.encode(subtitle.format, inherent: externalSubtitleDefaults.format, forKey: .bindSRTEncoding)
            options.encode(subtitle.offset, inherent: externalSubtitleDefaults.offset, forKey: .bindSRTOffset)
        }
    }
}

public let externalSubtitleDefaults = (language: "und", format: "latin1", offset: 0)

/// Information about an externale subtitle to add to the transcoded media
public struct ExternalSubtitle {
    fileprivate let file: FilePath
    fileprivate let language: String
    fileprivate let format: String
    fileprivate let offset: Int

    public init(file: FilePath, language: String = externalSubtitleDefaults.language,
                format: String = externalSubtitleDefaults.format, offset: Int = externalSubtitleDefaults.offset) {
        self.file = file
        self.language = language
        self.format = format
        self.offset = offset
    }
}
