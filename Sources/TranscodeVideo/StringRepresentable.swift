import struct TrailBlazer.DirectoryPath
import struct TrailBlazer.FilePath
import struct TrailBlazer.GenericPath
import protocol TrailBlazer.Path

public protocol StringRepresentable {
    var stringValue: String { get }
}

extension StringRepresentable where Self: RawRepresentable, Self.RawValue == String {
    public var stringValue: String { return rawValue }
}

extension StringRepresentable where Self: RawRepresentable, Self.RawValue: Numeric {
    public var stringValue: String { return "\(rawValue)" }
}

extension StringRepresentable {
    func toString() -> String {
        if stringValue.contains(" ") {
            return "\"\(stringValue)\""
        }
        return stringValue
    }
}

extension String: StringRepresentable {
    public var stringValue: String { return self }
}

extension Numeric {
    public var stringValue: String { return "\(self)" }
}

extension Int: StringRepresentable {}

extension Double: StringRepresentable {}

extension Path {
    public var stringValue: String {
        return absolute?.string ?? string
    }
}

extension GenericPath: StringRepresentable {}
extension FilePath: StringRepresentable {}
extension DirectoryPath: StringRepresentable {}
