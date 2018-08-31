import Foundation

public struct Logger {

    public static var standard = Logger(outputFile: stdout)
    public static var error = Logger(outputFile: stderr)

    // MARK: - Logging

    var outputFile: UnsafeMutablePointer<FILE>
    var outputHandler: (_: UnsafePointer<Int8>, _: UnsafeMutablePointer<FILE>) -> Int32 = fputs

    public init(outputFile: UnsafeMutablePointer<FILE>) {
        self.outputFile = outputFile
    }

    public func log(_ messages: [String] = []) {
        messages.forEach(log)
    }

    public func log(_ message: String = "") {
        _ = outputHandler(indentation + message + .newLine, stdout)
    }

    public func error(_ message: String = "") {
        _ = outputHandler(indentation + message + .newLine, stderr)
    }

    // MARK: - Integration

    public var indentationLevel = 0
    public var indentationStep = 2

    public mutating func indent(number: Int = 1) {
        indentationLevel = max(0, indentationLevel + 1 * number)
    }

    public mutating func outdent(number: Int = 1) {
        indentationLevel = max(0, indentationLevel - 1 * number)
    }

    var indentation: String {
        return Array(repeating: " ", count: indentationLevel * indentationStep).joined()
    }

}

// MARK: - String helper

extension String {
    static let newLine = "\n"
}
