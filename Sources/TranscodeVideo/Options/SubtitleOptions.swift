public let subtitleDefaults = (noAutoBurn: false, unusedButRequired: false)

/// Transcoder options relating to the subtitles contained within the video file
public struct SubtitleOptions: Optionable {
    /// Burn track selected by number into video or `scan` to find forced track in main audio language
    public var burnSubtitle: SubtitleTrack?
    /// Add track selected by number and set forced flag or scan for forced track in same language as main audio
    public var forceSubtitle: SubtitleTrack?
    /// Add track selected by number or add tracks selected with one or more language codes or add all tracks
    public var tracks: [SubtitleTrack]
    /// Don't automatically burn first forced subtitle
    public var noAutoBurn: Bool

    /**
     - Parameters:
       - burnSubtitle: Burn track selected by number into video or `scan` to find forced track in main audio language
       - forceSubtitle: Add track selected by number and set forced flag or scan for forced track in same language as
                        main audio
       - tracks: Add track selected by number or add tracks selected with one or more language codes or add all tracks
                 (language code must be ISO 639-2 format, e.g.: `eng`)
                 (multiple languages are separated by commas)
       - noAutoBurn: Don't automatically burn first forced subtitle
     */
    public init(burnSubtitle: SubtitleTrack? = nil, forceSubtitle: SubtitleTrack? = nil, tracks: [SubtitleTrack] = [],
                noAutoBurn: Bool = subtitleDefaults.noAutoBurn) {
        self.burnSubtitle = burnSubtitle
        self.forceSubtitle = forceSubtitle
        self.tracks = tracks
        self.noAutoBurn = noAutoBurn
    }

    enum ArgumentKeys: String, ArgumentKey {
        case burnSubtitle = "burn-subtitle"
        case forceSubtitle = "force-subtitle"
        case track = "add-subtitle"
        case noAutoBurn = "no-auto-burn"
    }

    func encode(to options: Options) {
        options.encode(burnSubtitle, forKey: .burnSubtitle)
        options.encode(forceSubtitle, forKey: .forceSubtitle)
        options.encode(tracks, forKey: .track)
        options.encode(noAutoBurn, inherent: subtitleDefaults.noAutoBurn, forKey: .noAutoBurn)
    }
}

/// Subtitle Track contained within the video file
public struct SubtitleTrack: StringRepresentable, ExpressibleByIntegerLiteral {
    public let stringValue: String

    /// Scan for a forced subtitle track in the video file
    public static let scan = SubtitleTrack("scan")
    /// Use all of the subtitle tracks in the video file
    public static let all = SubtitleTrack("all")

    /// Initialize using the subtitle track found at the specified index
    public init(integerLiteral value: Int) {
        self.init(track: value)
    }

    /// Initialize using the subtitle track found at the specified index
    public init(track: Int) {
        stringValue = "\(track)"
    }

    /// Initialize using the subtitle track with the ISO 639-2 language code
    public init(language: String) {
        self.init(language)
    }

    private init(_ str: String) {
        stringValue = str
    }
}
