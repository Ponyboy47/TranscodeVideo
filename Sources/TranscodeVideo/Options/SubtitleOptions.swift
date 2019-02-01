public struct SubtitleOptions: Optionable {
    public var burnSubtitle: SubtitleTrack?
    public var forceSubtitle: SubtitleTrack?
    public var tracks: [SubtitleTrack]
    public var noAutoBurn: Bool

    public init(burnSubtitle: SubtitleTrack? = nil, forceSubtitle: SubtitleTrack? = nil, tracks: [SubtitleTrack] = [], noAutoBurn: Bool = false) {
        self.burnSubtitle = burnSubtitle
        self.forceSubtitle = forceSubtitle
        self.tracks = tracks
        self.noAutoBurn = noAutoBurn
    }

    public enum ArgumentKeys: String, ArgumentKey {
        case burnSubtitle = "burn-subtitle"
        case forceSubtitle = "force-subtitle"
        case track = "add-subtitle"
        case noAutoBurn = "no-auto-burn"
    }

    public func encode(to options: Options) {
        options.encode(burnSubtitle, forKey: .burnSubtitle)
        options.encode(forceSubtitle, forKey: .forceSubtitle)
        options.encode(tracks, forKey: .track)
        options.encode(noAutoBurn, forKey: .noAutoBurn)
    }
}

public struct SubtitleTrack: StringRepresentable, ExpressibleByIntegerLiteral {
    public let stringValue: String

    public static let scan = SubtitleTrack("scan")
    public static let all = SubtitleTrack("all")

    public init(integerLiteral value: Int) {
        self.init(track: value)
    }

    public init(track: Int) {
        stringValue = "\(track)"
    }

    public init(language: String) {
        self.init(language)
    }

    private init(_ str: String) {
        stringValue = str
    }
}
