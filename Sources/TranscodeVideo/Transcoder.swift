import struct TrailBlazer.FilePath
import class Foundation.DispatchQueue
import struct Foundation.DispatchQoS
import class Foundation.Process
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

    public init(for file: FilePath, options: TranscoderOptions? = nil, onCompletion callback: ((AsyncCommand) -> Void)? = nil) {
        self.file = file
        self.options = options ?? TranscoderOptions()
        self.callback = callback
    }

    func output() -> ProcessOutput {
        return (command.stdout, command.stderror)
    }

    func start() {
        command = runAsync(transcodeVideoCommand, options.buildArguments() + [file.stringValue])
        if let callback = self.callback {
            command.onCompletion(callback)
        }
    }

    @discardableResult
    func wait() -> Int {
        return command.exitcode()
    }

    @discardableResult
    func finish() -> Process.TerminationReason {
        command.stdout.readData()
        return command.terminationReason()
    }

    func stop() {
        command.stop()
    }

    func interrupt() {
        command.interrupt()
    }

    @discardableResult
    func suspend() -> Bool {
        return command.suspend()
    }

    @discardableResult
    func resume() -> Bool {
        return command.resume()
    }
}
