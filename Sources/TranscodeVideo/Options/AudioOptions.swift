public let audioDefaults = (reverseDoubleOrder: false, keepAC3Stereo: false, ac3Encoder: AC3Encoder.ac3,
                            ac3BitRate: AC3BitRate.x640, passthroughAC3BitRate: AC3BitRate.x640,
                            mixdown: Mixdown.stereo, noAudio: false)

/// Options related to the audio output of the transcoded media
public struct AudioOptions: Optionable {
    /// Select main track by number or first with language code assigning it an optional name
    public var mainAudio: TrackName?
    /**
     Add track selected by number assigning it an optional name or add tracks selected with one or more language codes or
     add all tracks
     */
    public var tracks: [AudioTrack]
    /**
     Set audio output width for specific track by number or main track or other non-main tracks or all tracks with
     `double` to allow room for two output tracks with `surround` to allow single surround or stereo track with `stereo`
     to allow only single stereo track
     */
    public var widths: [AudioTrack: TrackWidth]
    /// Reverse order of `double` width audio output tracks
    public var reverseDoubleOrder: Bool
    /// Set audio format for specific or all output tracks
    public var audioFormats: [AudioFormat]
    /// Copy rather than transcode AC-3 stereo or mono audio tracks even when the current stereo format is AAC
    public var keepAC3Stereo: Bool
    /// Set AC-3 audio encoder
    public var ac3Encoder: AC3Encoder
    /// Set AC-3 surround audio bitrate
    public var ac3BitRate: AC3BitRate
    /// Set AC-3 surround pass-through bitrate
    public var passthroughAC3BitRate: AC3BitRate
    /**
     Try to copy track selected by number in its original format falling back to surround format if original not allowed
     or try to copy all tracks in same manner
     */
    public var copyAudio: [AudioTrack]
    /**
     Copy original track name selected by number unless the name is specified with another option or try to copy all
     track names in same manner
     */
    public var copyAudioNames: [AudioTrack]
    /// Use named AAC audio encoder
    public var aacEncoder: String?
    /// Set mixdown for stereo audio output tracks to regular stereo or Dolby Pro Logic II format
    public var mixdown: Mixdown
    /// Disable all audio output
    public var noAudio: Bool

    /**
     - Parameters:
       - mainAudio: Select main track by number or first with language code assigning it an optional name
                    (default: first track, i.e. 1)
                    (language code must be ISO 639-2 format, e.g.: `eng`)
                    (default output can be two audio tracks, both surround and stereo, i.e. width is `double`)
       - tracks: Add track selected by number assigning it an optional name or add tracks selected with one or more
                 language codes or add all tracks
                 (language code must be ISO 639-2 format, e.g.: `eng`)
                 (multiple languages are separated by commas)
                 (default output is single AAC audio track, i.e. width is `stereo`)
       - widths: Set audio output width for specific track by number or main track or other non-main tracks or all tracks
                 with `double` to allow room for two output tracks with `surround` to allow single surround or stereo
                 track with `stereo` to allow only single stereo track
       - reverseDoubleOrder: Reverse order of `double` width audio output tracks
       - audioFormats: Set audio format for specific or all output tracks
                       (default for surround: ac3; default for stereo: aac)
       - keepAC3Stereo: Copy rather than transcode AC-3 stereo or mono audio tracks even when the current stereo format
                        is AAC
       - ac3Encoder: Set AC-3 audio encoder
                     (default: ac3)
       - ac3BitRate: Set AC-3 surround audio bitrate
                     (default: 640)
       - passthroughAC3BitRate: Set AC-3 surround pass-through bitrate
                                (default: 640)
       - copyAudio: Try to copy track selected by number in its original format falling back to surround format if
                    original not allowed or try to copy all tracks in same manner
                    (only applies to main and explicitly added audio tracks)
       - copyAudioNames: Copy original track name selected by number unless the name is specified with another option or
                         try to copy all track names in same manner
                         (only applies to main and explicitly added audio tracks)
       - aacEncoder: Use named AAC audio encoder
                     (default: platform dependent)
       - mixdown: Set mixdown for stereo audio output tracks to regular stereo or Dolby Pro Logic II format
                  (default: stereo)
       - noAudio: Disable all audio output
     */
    public init(mainAudio: TrackName? = nil, tracks: [AudioTrack] = [], widths: [AudioTrack: TrackWidth] = [:],
                reverseDoubleOrder: Bool = audioDefaults.reverseDoubleOrder, audioFormats: [AudioFormat] = [],
                keepAC3Stereo: Bool = audioDefaults.keepAC3Stereo, ac3Encoder: AC3Encoder = audioDefaults.ac3Encoder,
                ac3BitRate: AC3BitRate = audioDefaults.ac3BitRate,
                passthroughAC3BitRate: AC3BitRate = audioDefaults.passthroughAC3BitRate, copyAudio: [AudioTrack] = [],
                copyAudioNames: [AudioTrack] = [], aacEncoder: String? = nil, mixdown: Mixdown = audioDefaults.mixdown,
                noAudio: Bool = audioDefaults.noAudio) {
        self.mainAudio = mainAudio
        self.tracks = tracks
        self.widths = widths
        self.reverseDoubleOrder = reverseDoubleOrder
        self.audioFormats = audioFormats
        self.keepAC3Stereo = keepAC3Stereo
        self.ac3Encoder = ac3Encoder
        self.ac3BitRate = ac3BitRate
        self.passthroughAC3BitRate = passthroughAC3BitRate
        self.copyAudio = copyAudio
        self.copyAudioNames = copyAudioNames
        self.aacEncoder = aacEncoder
        self.mixdown = mixdown
        self.noAudio = noAudio
    }

    enum ArgumentKeys: String, ArgumentKey {
        case mainAudio = "main-audio"
        case track = "add-audio"
        case width = "audio-width"
        case reverseDoubleOrder = "reverse-double-order"
        case audioFormat = "audio-format"
        case keepAC3Stereo = "keep-ac3-stereo"
        case ac3Encoder = "ac3-encoder"
        case ac3BitRate = "ac3-bitrate"
        case passthroughAC3BitRate = "pass-ac3-bitrate"
        case copyAudio = "copy-audio"
        case copyAudioName = "copy-audio-name"
        case aacEncoder = "aac-encoder"
        case mixdown
        case noAudio = "no-audio"
    }

    func encode(to options: Options) {
        options.encode(mainAudio, forKey: .mainAudio)
        options.encode(tracks, forKey: .track)
        for (track, width) in widths {
            options.encode("\(track.stringValue)=\(width.stringValue)", forKey: .width)
        }
        options.encode(reverseDoubleOrder, inherent: audioDefaults.reverseDoubleOrder, forKey: .reverseDoubleOrder)
        options.encode(audioFormats, forKey: .audioFormat)
        options.encode(keepAC3Stereo, inherent: audioDefaults.keepAC3Stereo, forKey: .keepAC3Stereo)
        options.encode(ac3Encoder, inherent: audioDefaults.ac3Encoder, forKey: .ac3Encoder)
        options.encode(ac3BitRate, inherent: audioDefaults.ac3BitRate, forKey: .ac3BitRate)
        options.encode(passthroughAC3BitRate, inherent: audioDefaults.passthroughAC3BitRate, forKey: .passthroughAC3BitRate)
        options.encode(copyAudio, forKey: .copyAudio)
        options.encode(copyAudioNames, forKey: .copyAudio)
        options.encode(aacEncoder, forKey: .aacEncoder)
        options.encode(mixdown, inherent: audioDefaults.mixdown, forKey: .mixdown)
        options.encode(noAudio, inherent: audioDefaults.noAudio, forKey: .noAudio)
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

public struct AudioFormat: StringRepresentable {
    public enum Track: String {
        case surround
        case stereo
        case all
    }

    public enum Format: String {
        case ac3
        case aac
    }

    public let stringValue: String

    public init(track: Track, format: Format) {
        stringValue = "\(track.rawValue)=\(format.rawValue)"
    }
}

public enum AC3Encoder: String, StringRepresentable {
    case ac3
    case eac3
}

public enum AC3BitRate: Int, StringRepresentable {
    case x384 = 384
    case x448 = 448
    case x640 = 640
    case x768 = 768
    case x1536 = 1536
}

public enum Mixdown: String, StringRepresentable {
    case stereo
    case dpl2
}
