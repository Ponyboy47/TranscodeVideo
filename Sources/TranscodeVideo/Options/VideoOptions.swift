public struct VideoOptions: Optionable {
    public var crop: CropDimensions?
    public var constrainCrop: Bool
    public var fallbackCrop: FallbackCrop?
    public var fitTo720p: Bool
    public var maxWidth: Int?
    public var maxHeight: Int?
    public var aspectRatio: AspectRatio?
    public var frameRate: FrameRate?
    public var filters: [KeyValueOption]

    public init(crop: CropDimensions? = nil, constrainCrop: Bool = false, fallbackCrop: FallbackCrop? = nil, fitTo720p: Bool = false, maxWidth: Int? = nil, maxHeight: Int? = nil, aspectRatio: AspectRatio? = nil, frameRate: FrameRate? = nil, filters: [KeyValueOption] = []) {
        self.crop = crop
        self.constrainCrop = constrainCrop
        self.fallbackCrop = fallbackCrop
        self.fitTo720p = fitTo720p
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.aspectRatio = aspectRatio
        self.frameRate = frameRate
        self.filters = filters
    }

    public enum ArgumentKeys: String, ArgumentKey {
        case crop
        case constrainCrop = "contrain-crop"
        case fallbackCrop = "fallback-crop"
        case hq = "720p"
        case maxWidth = "max-width"
        case maxHeight = "max-height"
        case aspectRatio = "pixel-aspect"
        case forceFrameRate = "force-rate"
        case maxFrameRate = "limit-rate"
        case filter
    }

    public func encode(to options: Options) {
        options.encode(crop, forKey: .crop)
        options.encode(constrainCrop, forKey: .constrainCrop)
        options.encode(fallbackCrop, forKey: .fallbackCrop)
        options.encode(fitTo720p, forKey: .hq)
        options.encode(maxWidth, forKey: .maxWidth)
        options.encode(maxHeight, forKey: .maxHeight)
        options.encode(aspectRatio, forKey: .aspectRatio)
        if let frameRate = frameRate {
            switch frameRate {
            case .forced(let rate): options.encode(rate, forKey: .forceFrameRate)
            case .max(let rate): options.encode(rate, forKey: .maxFrameRate)
            }
        }
        options.encode(filters, forKey: .filter)
    }
}

public enum CropDimensions: StringRepresentable {
    public var stringValue: String {
        switch self {
        case .detect: return "detect"
        case .auto: return "auto"
        case .zero: return "0:0:0:0"
        case .custom(let top, let bottom, let left, let right): return "\(top):\(bottom):\(left):\(right)"
        }
    }

    case detect
    case auto
    case zero
    case custom(top: Int, bottom: Int, left: Int, right: Int)
}

public enum FallbackCrop: String, StringRepresentable {
    case handbrake
    case ffmpeg
    case none
}

public enum AspectRatio: StringRepresentable {
    public var stringValue: String {
        switch self {
        case .square: return "1:1"
        case .custom(let x, let y): return "\(x):\(y)"
        }
    }

    case square
    case custom(x: Int, y: Int)
}

public enum FrameRate {
    case forced(Int)
    case max(Int)
}
