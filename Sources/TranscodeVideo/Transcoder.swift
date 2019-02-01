import struct TrailBlazer.FilePath
import struct Foundation.CharacterSet
import class Foundation.Process
import class Foundation.DispatchQueue
import class Foundation.DispatchWorkItem
import class SwiftShell.AsyncCommand
import protocol SwiftShell.ReadableStream
import func SwiftShell.runAsync

public let transcodeVideoCommand = "transcode-video"
public typealias ProcessOutput = (stdout: ReadableStream, stderr: ReadableStream)

public final class Transcoder {
    public let file: FilePath
    public let options: TranscoderOptions
    private var command: AsyncCommand!
    private let callback: ((AsyncCommand) -> Void)?
    private var beenStarted = false
    private var lastProgressLine: String?
    private var latestProgressLine: String? {
        willSet {
            guard lastProgressLine != newValue else { return }
            lastProgressLine = latestProgressLine

            guard let progressLine = newValue else { return }
            updateProgressPct(progressLine)
        }
    }
    private var lastETALine: String?
    private var latestETALine: String? {
        willSet {
            guard lastETALine != newValue else { return }
            lastETALine = latestETALine

            guard let etaLine = newValue else { return }
            updateETA(etaLine)
        }
    }
    public private(set) var eta: (hours: Int, minutes: Int, seconds: Int) = (hours: -1, minutes: -1, seconds: -1)
    private var _progress: Double = 0.0
    public var progress: Double { return _progress / 100.0 }

    #if os(Linux)
    private let readabilityQueue = DispatchQueue(label: "com.jtw.transcode-video")
    private var readabilityWorker: DispatchWorkItem!
    #endif

    public init(for file: FilePath, options: TranscoderOptions? = nil, onCompletion callback: ((AsyncCommand) -> Void)? = nil) {
        self.file = file
        self.options = options ?? TranscoderOptions()
        self.callback = callback
    }

    public func output() -> ProcessOutput {
        return (stdout: command.stdout, stderr: command.stderror)
    }

    public func start() {
        // Prevent running a transcode command multiple times
        guard !beenStarted else { return }
        defer { beenStarted = true }

        command = runAsync(transcodeVideoCommand, options.buildArguments() + [file.stringValue])

        if let callback = self.callback {
            command.onCompletion(callback)
        }

        #if os(macOS)
        command.stdout.onTextOutput { string in
            latestProgressLine = string.components(separatedBy: .newlines).reversed().first(where: { $0.contains(" %") })
            latestETALine = string.components(separatedBy: .newlines).reversed().first(where: { $0.contains("ETA ") })
        }
        #else
        self.readabilityWorker = DispatchWorkItem(qos: .background) {
            while let stdout = self.command.stdout.readSome() {
                let reversedStdout = stdout.components(separatedBy: .newlines).reversed()
                self.latestProgressLine = reversedStdout.first(where: { $0.contains(" %") })
                self.latestETALine = reversedStdout.first(where: { $0.contains("ETA ") })
            }
        }

        readabilityQueue.async(execute: readabilityWorker)
        #endif
    }

    public func wait() {
        command.stdout.readData()
        #if os(Linux)
        readabilityWorker.cancel()
        #endif
    }

    @discardableResult
    public func finish() -> (exitcode: Int, reason: Process.TerminationReason) {
        wait()
        return (exitcode: command.exitcode(), reason: command.terminationReason())
    }

    public func stop() {
        command.stop()
        #if os(Linux)
        readabilityWorker.cancel()
        #endif
    }

    public func interrupt() {
        command.interrupt()
        #if os(Linux)
        readabilityWorker.cancel()
        #endif
    }

    @discardableResult
    public func suspend() -> Bool {
        return command.suspend()
    }

    @discardableResult
    public func resume() -> Bool {
        return command.resume()
    }

    private func updateProgressPct(_ line: String) {
        guard let pre = line.components(separatedBy: " %").first else { return }
        guard let num = pre.components(separatedBy: .whitespaces).reversed().first else { return }
        guard let progress = Double(num), progress > _progress else { return }

        _progress = progress
    }

    private func updateETA(_ line: String) {
        guard let post = line.components(separatedBy: "ETA ").last else { return }

        let parts = post.components(separatedBy: "h")

        guard parts.count == 2 else { return }
        guard let subparts = parts.last?.components(separatedBy: "m"), subparts.count == 2 else { return }
        guard let hourStr = parts.first, let hours = Int(hourStr) else { return }
        guard let minuteStr = subparts.first, let minutes = Int(minuteStr) else { return }
        guard let secondStr = subparts.last?.components(separatedBy: "s").first, let seconds = Int(secondStr) else { return }

        eta = (hours: hours, minutes: minutes, seconds: seconds)
    }
}
