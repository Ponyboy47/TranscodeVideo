public let videoDefaults = (crop: CropDimensions.zero, constrainCrop: false, fitTo720p: false,
                            pixelAspectRatio: AspectRatio.square)

/// Options relating to the video output of the transcoded media
public struct VideoOptions: Optionable {
    /// Set video crop values
    public var crop: CropDimensions
    /// Constrain `crop detect` to optimal shape
    public var constrainCrop: Bool
    /// Select fallback crop values if `crop detect` fails
    public var fallbackCrop: FallbackCrop?
    /// Fit video within 1280x720 pixel bounds
    public var fitTo720p: Bool
    /// Fit video within horizontal pixel bounds
    public var maxWidth: Int?
    /// Fit video within vertical pixel bounds
    public var maxHeight: Int?
    /// Set pixel aspect ratio
    public var pixelAspectRatio: AspectRatio
    /// Set forced or limited video fram rate
    public var frameRate: FrameRate?
    /// Apply `HandBrakeCLI` video filter with optional settings
    public var filters: [KeyValueOption]

    /**
     - Parameters:
       - crop: Set video crop values
               (default: 0:0:0:0)
               (use `detect` for `detect-crop` behavior)
               (use `auto` for `HandBrakeCLI` behavior)
       - constrainCrop: Constrain `crop detect` to optimal shape
       - fallbackCrop: Select fallback crop values if `crop detect` fails
                       (handbrake | ffmpeg | minimal | none)
                       (`minimal` uses the smallest possible crop values combining results from `HandBrakeCLI` and
                       `ffmpeg`)
       - fitTo720p: Fit video within 1280x720 pixel bounds
       - maxWidth: Fit video within horizontal pixel bounds
       - maxHeight: Fit video within vertical pixel bounds
       - pixelAspectRatio: Set pixel aspect ratio
                           (default: 1:1)
                           (e.g.: make X larger than Y to stretch horizontally)
       - frameRate: Set forced or limited video fram rate
                    ([forced= | max=]RATE)
                    forced: Force constant video frame rate
                            (`23.976` applied automatically for some inputs)
                    max: Set peak-limited video frame rate
       - filters: Apply `HandBrakeCLI` video filter with optional settings
                  (`deinterlace` applied automatically for some inputs)
                  (refer to `HandBrakeCLI --help` for more information)
     */
    public init(crop: CropDimensions = videoDefaults.crop, constrainCrop: Bool = videoDefaults.constrainCrop,
                fallbackCrop: FallbackCrop? = nil, fitTo720p: Bool = videoDefaults.fitTo720p, maxWidth: Int? = nil,
                maxHeight: Int? = nil, pixelAspectRatio: AspectRatio = videoDefaults.pixelAspectRatio,
                frameRate: FrameRate? = nil, filters: [KeyValueOption] = []) {
        self.crop = crop
        self.constrainCrop = constrainCrop
        self.fallbackCrop = fallbackCrop
        self.fitTo720p = fitTo720p
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.pixelAspectRatio = pixelAspectRatio
        self.frameRate = frameRate
        self.filters = filters
    }

    enum ArgumentKeys: String, ArgumentKey {
        case crop
        case constrainCrop = "contrain-crop"
        case fallbackCrop = "fallback-crop"
        case hq = "720p"
        case maxWidth = "max-width"
        case maxHeight = "max-height"
        case pixelAspectRatio = "pixel-aspect"
        case forcedFrameRate = "force-rate"
        case maxFrameRate = "limit-rate"
        case filter
    }

    func encode(to options: Options) {
        options.encode(crop, inherent: videoDefaults.crop, forKey: .crop)
        options.encode(constrainCrop, inherent: videoDefaults.constrainCrop, forKey: .constrainCrop)
        options.encode(fallbackCrop, forKey: .fallbackCrop)
        options.encode(fitTo720p, inherent: videoDefaults.fitTo720p, forKey: .hq)
        options.encode(maxWidth, forKey: .maxWidth)
        options.encode(maxHeight, forKey: .maxHeight)
        options.encode(pixelAspectRatio, inherent: videoDefaults.pixelAspectRatio, forKey: .pixelAspectRatio)
        if let frameRate = frameRate {
            switch frameRate.type {
            case .forced: options.encode(frameRate.rate, forKey: .forcedFrameRate)
            case .max: options.encode(frameRate.rate, forKey: .maxFrameRate)
            }
        }
        options.encode(filters, forKey: .filter)
    }
}

/// Crop dimensions for input media
public enum CropDimensions: StringRepresentable, Equatable {
    public var stringValue: String {
        switch self {
        case .detect: return "detect"
        case .auto: return "auto"
        case .zero: return "0:0:0:0"
        case .custom(let top, let bottom, let left, let right): return "\(top):\(bottom):\(left):\(right)"
        }
    }

    /// Uses the detect-crop utility to determine the crop dimensions
    case detect
    /// Uses HandBrakeCLI to determine the crop dimensions
    case auto
    /// No cropping
    case zero
    /// Custome cropping dimensions
    case custom(top: Int, bottom: Int, left: Int, right: Int)
}

/// The type of crop to fall back on when the detect fails
public enum FallbackCrop: String, StringRepresentable {
    /// Uses HandBrakeCLI to determine the crop dimensions
    case handbrake
    /// Uses ffmpeg to determine the crop dimensions
    case ffmpeg
    /// Uses the smallest possible crop values combining the results from HandBrakeCLI and ffmpeg
    case minimal
    /// Don't crop
    case none
}

/// Stretch pixels by applying an AspectRatio during transcoding
public enum AspectRatio: StringRepresentable, Equatable {
    public var stringValue: String {
        switch self {
        case .square: return "1:1"
        case .custom(let x, let y): return "\(x):\(y)"
        }
    }

    /// No stretch
    case square
    /// Custom stretch
    case custom(x: Int, y: Int)
}

/// Apply either a peak limited or forced video frame rate
public struct FrameRate: StringRepresentable {
    public let stringValue: String

    public let type: FrameRateType
    public let rate: Double

    public enum FrameRateType: String {
        case forced
        case max
    }

    public init(type: FrameRateType, frameRate: Double) {
        stringValue = "\(type)=\(frameRate)"
        self.type = type
        rate = frameRate
    }

    /// Force a constant frame rate
    public static func forced(_ frameRate: Double) -> FrameRate {
        return .init(type: .forced, frameRate: frameRate)
    }

    /// Set a peak-limited variable frame rate
    public static func max(_ frameRate: Double) -> FrameRate {
        return .init(type: .max, frameRate: frameRate)
    }
}
