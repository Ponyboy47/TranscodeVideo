public struct TranscoderOptions {
    public let input: InputOptions
    public let output: OutputOptions?
    public let quality: QualityOptions?
    public let video: VideoOptions?
    public let audio: AudioOptions?
    public let subtitle: SubtitleOptions?
    public let externalSubtitle: ExternalSubtitleOptions?
    public let advanced: AdvancedOptions?
    public let diagnostic: DiagnosticOptions?

    public init(input: InputOptions, output: OutputOptions? = nil, quality: QualityOptions? = nil, video: VideoOptions? = nil, audio: AudioOptions? = nil, subtitle: SubtitleOptions? = nil, externalSubtitle: ExternalSubtitleOptions? = nil, advanced: AdvancedOptions? = nil, diagnostic: DiagnosticOptions? = nil) {
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
        return input.buildOptions() + output?.buildOptions() + quality?.buildOptions() + video?.buildOptions() + audio?.buildOptions() + subtitle?.buildOptions() + externalSubtitle?.buildOptions() + advanced?.buildOptions() + diagnostic?.buildOptions() + [input.source.stringValue]
    }
}

// These allow the buildArguments function above to Type check instantly.
// Without them, the expression will fail type checking after attempting to
// build for over a minute
private func + (lhs: [String], rhs: [String]?) -> [String] {
    if let rhs = rhs {
        return lhs + rhs
    }
    return lhs
}
private func + (lhs: [String]?, rhs: [String]?) -> [String] {
    guard let lhs = lhs else {
        return rhs ?? []
    }
    guard let rhs = rhs else { return [] }
    return lhs + rhs
}
