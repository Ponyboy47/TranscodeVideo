import struct TrailBlazer.FilePath
import class Foundation.DispatchQueue

public struct Transcoder {
    public let queue: DispatchQueue = .global(qos: .utility)

    public init(from path: FilePath) {
    }

    public init?(from path: String) {
        guard let path = FilePath(path) else { return nil }
        self.init(from: path)
    }

    func transcode() {
    }

    func status() {
    }

    func wait() {
    }
}
