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
    private var lastProgressLine: String?
    private var latestProgressLine: String? {
        willSet {
            guard lastProgressLine != newValue else { return }
            lastProgressLine = latestProgressLine

            guard let progressLine = newValue else { return }
            guard progressLine.contains("%") else { return }

            for word in progressLine.components(separatedBy: "%").first!.components(separatedBy: .whitespaces).reversed() {
                guard !word.isEmpty else { continue }
                guard let progress = Double(word), progress > _progress else { continue }
                self._progress = progress
            }
        }
    }
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
        #if os(Linux)
        self.readabilityWorker = DispatchWorkItem(qos: .background) {
            while let stdout = self.command.stdout.readSome() {
                self.latestProgressLine = stdout.components(separatedBy: .newlines).reversed().first(where: { $0.contains("Encoding: task") })
            }
        }
        #endif
    }

    public func output() -> ProcessOutput {
        return (command.stdout, command.stderror)
    }

    public func start() {
        command = runAsync(transcodeVideoCommand, options.buildArguments() + [file.stringValue])

        if let callback = self.callback {
            command.onCompletion(callback)
        }

        #if os(macOS)
        command.stdout.onTextOutput { string in
            latestProgressLine = string.components(separatedBy: .newlines).reversed().first(where: { $0.contains("Encoding: task") })
        }
        #else
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
    public func finish() -> (Int, Process.TerminationReason) {
        wait()
        return (command.exitcode(), command.terminationReason())
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
}
