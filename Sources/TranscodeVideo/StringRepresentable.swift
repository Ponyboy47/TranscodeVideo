public protocol StringRepresentable {
    var stringValue: String { get }
}

extension StringRepresentable where Self: RawRepresentable, Self.RawValue == String {
    public var stringValue: String { return rawValue }
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

extension Int: StringRepresentable {
    public var stringValue: String { return "\(self)" }
}

extension Double: StringRepresentable {
    public var stringValue: String { return "\(self)" }
}
