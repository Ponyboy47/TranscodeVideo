public struct QualityOptions: Optionable {
    public var encoder: HandbrakeEncoder
    public var ratecontrol: RateControl?
    public var size: TargetSize?
    public var bitRates: [TargetBitRate]
    public var speed: TranscodeSpeed?
    public var preset: TranscodePreset?

    public enum ArgumentKeys: String, ArgumentKey {
        case encoder
        case abr
        case simple
        case abvr
        case target
        case quick
        case veryquick
        case preset
    }

    public init(encoder: HandbrakeEncoder = .x264, ratecontrol: RateControl? = nil, size: TargetSize? = nil,
                bitRates: [TargetBitRate] = [], speed: TranscodeSpeed? = nil, preset: TranscodePreset? = nil) {
        self.encoder = encoder
        self.ratecontrol = ratecontrol
        self.size = size
        self.bitRates = bitRates
        self.speed = speed
        self.preset = preset
    }

    public func encode(to options: Options) {
        options.encode(encoder, forKey: .encoder)

        if let ratecontrol = self.ratecontrol {
            switch ratecontrol {
            case .abr: options.encode(true, forKey: .abr)
            case .simple: options.encode(true, forKey: .simple)
            case .abvr: options.encode(true, forKey: .abvr)
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

public enum HandbrakeEncoder: String, StringRepresentable {
    case x264
    case x264_10bit
    case x265
    case x265_10bit
    case x265_12bit
    case mpeg4
    case mpeg2
    case vp8 = "VP8"
    case vp9 = "VP9"
    case theora
}

public enum RateControl: String {
    case abr
    case simple
    case abvr
}

public enum TargetSize: String, StringRepresentable {
    case small
    case big
}

public struct TargetBitRate: StringRepresentable {
    public let stringValue: String

    public init(_ output: OutputSize, bitRate: Int) {
        stringValue = "\(output.rawValue)p=\(bitRate)"
    }
}

public enum OutputSize: Int {
    case fourk = 2160
    case hd = 1080
    case hq = 720
    case sd = 480
}

public enum TranscodeSpeed: String {
    case quick
    case veryquick
}

public enum TranscodePreset: String, StringRepresentable {
    case veryslow
    case slower
    case slow
    case fast
    case faster
    case veryfast
}
