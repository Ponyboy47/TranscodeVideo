public struct TranscoderOptions {
    public var input: InputOptions?
    public var output: OutputOptions?
    public var quality: QualityOptions?
    public var video: VideoOptions?
    public var audio: AudioOptions?
    public var subtitle: SubtitleOptions?
    public var externalSubtitle: ExternalSubtitleOptions?
    public var advanced: AdvancedOptions?
    public var diagnostic: DiagnosticOptions?

    public init(input: InputOptions? = nil, output: OutputOptions? = nil, quality: QualityOptions? = nil,
                video: VideoOptions? = nil, audio: AudioOptions? = nil, subtitle: SubtitleOptions? = nil,
                externalSubtitle: ExternalSubtitleOptions? = nil, advanced: AdvancedOptions? = nil,
                diagnostic: DiagnosticOptions? = nil) {
        self.input = input
        self.output = output
        self.quality = quality
        self.video = video
        self.audio = audio
        self.subtitle = subtitle
        self.externalSubtitle = externalSubtitle
        self.advanced = advanced
        self.diagnostic = diagnostic
    }

    public func buildArguments() -> [String] {
        return input?.buildOptions() + output?.buildOptions() + quality?.buildOptions() + video?.buildOptions()
            + audio?.buildOptions() + subtitle?.buildOptions() + externalSubtitle?.buildOptions()
            + advanced?.buildOptions() + diagnostic?.buildOptions()
    }
}

// These allow the buildArguments function above to Type check instantly.
// Without this, the expression will fail type checking after attempting to
// build for over a minute
private func + (lhs: [String]?, rhs: [String]?) -> [String] {
    guard let lhs = lhs else {
        return rhs ?? []
    }
    guard let rhs = rhs else { return [] }
    return lhs + rhs
}
