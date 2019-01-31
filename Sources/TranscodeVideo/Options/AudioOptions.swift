public struct AudioOptions: Optionable {
    public let mainAudio: TrackName?
    public let tracks: [AudioTrack]
    public let widths: [AudioTrack: TrackWidth]
    public let reverseDoubleOrder: Bool
    public let preferAC3: Bool
    public let ac3Encoder: AC3Encoder?
    public let ac3BitRate: AC3BitRate?
    public let passthroughAC3BitRate: AC3BitRate?
    public let copyAudio: [AudioTrack]
    public let copyAudioNames: [AudioTrack]
    public let aacEncoder: String?
    public let noAudio: Bool

    public init(mainAudio: TrackName? = nil, tracks: [AudioTrack] = [], widths: [AudioTrack: TrackWidth] = [:], reverseDoubleOrder: Bool = false, preferAC3: Bool = false, ac3Encoder: AC3Encoder? = nil, ac3BitRate: AC3BitRate? = nil, passthroughAC3BitRate: AC3BitRate? = nil, copyAudio: [AudioTrack] = [], copyAudioNames: [AudioTrack] = [], aacEncoder: String? = nil, noAudio: Bool = false) {
        self.mainAudio = mainAudio
        self.tracks = tracks
        self.widths = widths
        self.reverseDoubleOrder = reverseDoubleOrder
        self.preferAC3 = preferAC3
        self.ac3Encoder = ac3Encoder
        self.ac3BitRate = ac3BitRate
        self.passthroughAC3BitRate = passthroughAC3BitRate
        self.copyAudio = copyAudio
        self.copyAudioNames = copyAudioNames
        self.aacEncoder = aacEncoder
        self.noAudio = noAudio
    }

    public enum ArgumentKeys: String, ArgumentKey {
        case mainAudio = "main-audio"
        case track = "add-audio"
        case width = "audio-width"
        case reverseDoubleOrder = "reverse-double-order"
        case preferAC3 = "prefer-ac3"
        case ac3Encoder = "ac3-encoder"
        case ac3BitRate = "ac3-bitrate"
        case passthroughAC3BitRate = "pass-ac3-bitrate"
        case copyAudio = "copy-audio"
        case copyAudioName = "copy-audio-name"
        case aacEncoder = "aac-encoder"
        case noAudio = "no-audio"
    }

    public func encode(to options: Options) {
        options.encode(mainAudio, forKey: .mainAudio)
        options.encode(tracks, forKey: .track)
        for (track, width) in widths {
            options.encode("\(track.stringValue)=\(width.stringValue)", forKey: .width)
        }
        options.encode(reverseDoubleOrder, forKey: .reverseDoubleOrder)
        options.encode(preferAC3, forKey: .preferAC3)
        options.encode(ac3Encoder, forKey: .ac3Encoder)
        options.encode(ac3BitRate, forKey: .ac3BitRate)
        options.encode(passthroughAC3BitRate, forKey: .passthroughAC3BitRate)
        options.encode(copyAudio, forKey: .copyAudio)
        options.encode(copyAudioNames, forKey: .copyAudio)
        options.encode(aacEncoder, forKey: .aacEncoder)
        options.encode(noAudio, forKey: .noAudio)
    }
}

public struct TrackName: StringRepresentable {
    public let stringValue: String

    public init(track: AudioTrack, name: String? = nil) {
        if let name = name {
            stringValue = "\(track.stringValue)=\(name)"
        } else {
            stringValue = track.stringValue
        }
    }
}

public struct AudioTrack: StringRepresentable, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, Hashable {
    public let stringValue: String

    public static let all: AudioTrack = "all"
    public static let main: AudioTrack = "main"
    public static let other: AudioTrack = "other"

    public init(track: Int) {
        stringValue = "\(track)"
    }

    public init(language: String) {
        stringValue = language
    }

    public init(stringLiteral value: String) {
        self.init(language: value)
    }

    public init(integerLiteral value: Int) {
        self.init(track: value)
    }
}

public enum TrackWidth: String, StringRepresentable {
    case double
    case surround
    case stereo
}

public enum AC3Encoder: String, StringRepresentable {
    case ac3
    case eac3
}

public enum AC3BitRate: Int, StringRepresentable {
    public var stringValue: String { return "\(self.rawValue)" }

    case x384 = 384
    case x448 = 448
    case x640 = 640
    case x768 = 768
    case x1536 = 1536
}
