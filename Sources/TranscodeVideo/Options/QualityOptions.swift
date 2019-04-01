public let qualityDefaults = (encoder: HandbrakeEncoder.x264, unusedButRequired: false)

/// Options related to the quality output of the transcoded media
public struct QualityOptions: Optionable {
    /// Use named video encoder
    public var encoder: HandbrakeEncoder
    /// Set the system of quality rate control to use
    public var ratecontrol: RateControl?
    /// Apply video bitrate target macro for all input resolutions
    public var size: TargetSize?
    /// Set video bitrate target or target for specific input resolution
    public var bitRates: [TargetBitRate]
    /// Set the preferred encoding speed
    public var speed: TranscodeSpeed?
    /// Apply video encoder preset
    public var preset: TranscodePreset?

    enum ArgumentKeys: String, ArgumentKey {
        case encoder
        case abr
        case simple
        case avbr
        case target
        case quick
        case veryquick
        case preset
    }

    /**
     - Parameters:
       - encoder: use named video encoder
                  (default: x264)
                  (refer to `HandBrakeCLI --help` for available encoders)
       - ratecontrol: Set the system of quality rate control to use
                      (abr | simple | avbr)
                      abr: use constrained average bitrate (ABR) ratecontrol
                           (predictable size with different quality than default)
                      simple: use simple constrained ratecontrol
                              (limited size with different quality than default)
                      avbr: use average variable bitrate (AVBR) ratecontrol
                            (size near target with different quality than default)
                            (only available with x264 and x264_10bit encoders)
       - size: Apply video bitrate target macro for all input resolutions
               (big or small)
               big: trades some size for increased quality
               small: trades some quality for reduced size
       - bitRates: Set video bitrate target or target for specific input resolution
                   ((default: based on input)
                   ([2160p= | 1080p= | 720p= | 480p=]BITRATE)
                   (can be exceeded to maintain video quality)
       - speed: Set the preferred encoding speed
                (quick or veryquick)
                quick: increase encoding speed by 70-80% with no easily perceptible loss in video quality
                       (avoids quality problems with some encoder presets)
                 veryquick: increase encoding speed by 90-125% with little easily perceptible loss in video quality
                            (unlike `quick`, output size is larger than default)
       - preset: Apply video encoder preset
                 (veryfast | faster | fast | slow | slower | veryslow)
     */
    public init(encoder: HandbrakeEncoder = qualityDefaults.encoder, ratecontrol: RateControl? = nil,
                size: TargetSize? = nil, bitRates: [TargetBitRate] = [], speed: TranscodeSpeed? = nil,
                preset: TranscodePreset? = nil) {
        self.encoder = encoder
        self.ratecontrol = ratecontrol
        self.size = size
        self.bitRates = bitRates
        self.speed = speed
        self.preset = preset
    }

    func encode(to options: Options) {
        options.encode(encoder, inherent: qualityDefaults.encoder, forKey: .encoder)

        if let ratecontrol = self.ratecontrol {
            switch ratecontrol {
            case .abr: options.encode(true, forKey: .abr)
            case .simple: options.encode(true, forKey: .simple)
            case .avbr: options.encode(true, forKey: .avbr)
            }
        }

        options.encode(size, forKey: .target)
        options.encode(bitRates, forKey: .target)

        if let speed = self.speed {
            switch speed {
            case .quick: options.encode(true, forKey: .quick)
            case .veryquick: options.encode(true, forKey: .veryquick)
            }
        }

        options.encode(preset, forKey: .preset)
    }
}

/**
 The encoder for Handbrake to use when transcoding media

 There are a set of static variables on the struct with the default encoders available
 NOTE: These static variables do not reflect all possibilities, just the ones that were available on my Ubuntu 18.04 and
 macOS systems at the time I built this library. You may initialize your own HandbrakeEncoder with a String of the name
 of the encoder
 */
public struct HandbrakeEncoder: RawRepresentable, ExpressibleByStringLiteral, StringRepresentable, Equatable {
    public let rawValue: String

    public static let x264: HandbrakeEncoder = "x264"
    public static let x265: HandbrakeEncoder = "x265"
    public static let x265_10bit: HandbrakeEncoder = "x265_10bit"
    public static let x265_12bit: HandbrakeEncoder = "x265_12bit"
    public static let mpeg4: HandbrakeEncoder = "mpeg4"
    public static let mpeg2: HandbrakeEncoder = "mpeg2"
    public static let vp8: HandbrakeEncoder = "VP8"
    public static let vp9: HandbrakeEncoder = "VP9"
    public static let theora: HandbrakeEncoder = "theora"

    // Based on a standard Ubuntu 18.04 install compared to my macBook Pro,
    // this encoder was only available by default on Ubuntu (so only expose it
    // there by default)
    #if os(Linux)
    public static let x264_10bit: HandbrakeEncoder = "x264_10bit"
    #endif

    public static func custom(_ value: String) -> HandbrakeEncoder {
        return .init(rawValue: value)
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

/// The quality rate control systems available to transcode media
public enum RateControl: String {
    /**
     Constrained average bitrate (ABR) ratecontrol
     (predictable size with different quality than default)
     */
    case abr
    /**
     Simple constrained ratecontrol
     (limited size with different quality than default)
     */
    case simple
    /**
     Average variable bitrate (AVBR) ratecontrol
     (size near target with different quality than default)
     (only available with x264 and x264_10bit encoders)
     */
    case avbr
}

/// The size targets to use when transcoding media
public enum TargetSize: String, StringRepresentable {
    /// Trades some quality for reduced size
    case small
    /// Trades some size for increased quality
    case big
}

/// Video bitrate target or target for specific input resolution
public struct TargetBitRate: StringRepresentable {
    public let stringValue: String

    public init(_ output: OutputSize? = nil, bitRate: Int) {
        if let out = output {
            stringValue = "\(out.rawValue)p=\(bitRate)"
        } else {
            stringValue = "\(bitRate)"
        }
    }
}

/// Available input resolutions for transcoding media
public enum OutputSize: Int {
    /// 4K (2160p)
    case fourk = 2160
    /// High Definition (1080p)
    case hd = 1080
    /// High Quality (720p)
    case hq = 720
    /// Standard Definition (480p)
    case sd = 480
}

/// Options for increasing transcode speed
public enum TranscodeSpeed: String {
    /**
     Increase encoding speed by 70-80% with no easily perceptible loss in video quality
     (avoids quality problems with some encoder presets)
     */
    case quick
    /**
     Increase encoding speed by 90-125% with little easily perceptible loss in video quality
     (unlike `quick`, output size is larger than default)
     */
    case veryquick
}

/// Available video encoder presets
public enum TranscodePreset: String, StringRepresentable {
    case veryslow
    case slower
    case slow
    case fast
    case faster
    case veryfast
}
