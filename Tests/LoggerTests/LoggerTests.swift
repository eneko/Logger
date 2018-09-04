import XCTest
@testable import Logger

final class LoggerTests: XCTestCase {

    func testStandardOutput() {
        var logger = Logger.standard
        logger.outputHandler = { bytes, file in
            let message = String(cString: bytes)
            XCTAssertEqual(message, "Foo\n")
            XCTAssertEqual(file, stdout)
            return 0
        }
        logger.log("Foo")
    }

    func testStandardError() {
        var logger = Logger.error
        logger.outputHandler = { bytes, file in
            let message = String(cString: bytes)
            XCTAssertEqual(message, "Foo\n")
            XCTAssertEqual(file, stderr)
            return 0
        }
        logger.log("Foo")
    }

    func testEmpty() {
        var logger = Logger.standard
        logger.outputHandler = { bytes, file in
            let message = String(cString: bytes)
            XCTAssertEqual(message, "\n")
            XCTAssertEqual(file, stdout)
            return 0
        }
        logger.log()
    }

    func testArray() {
        var logger = Logger(outputFile: stdout)
        logger.outputHandler = { bytes, file in
            XCTAssertTrue(["Foo\n", "Bar\n", "Baz\n"].contains(String(cString: bytes)))
            return 0
        }
        logger.log(["Foo", "Bar", "Baz"])
    }

    func testIndent() {
        var logger = Logger(outputFile: stdout)
        logger.indent()
        XCTAssertEqual(logger.indentationLevel, 1)
        logger.indent()
        XCTAssertEqual(logger.indentationLevel, 2)
    }

    func testOutdent() {
        var logger = Logger(outputFile: stdout)
        logger.outdent()
        XCTAssertEqual(logger.indentationLevel, 0)
        logger.indent()
        logger.outdent()
        XCTAssertEqual(logger.indentationLevel, 0)
    }

    func testIndentationStep() {
        var logger = Logger(outputFile: stdout)
        logger.indentationStep = 10
        logger.indent()
        XCTAssertEqual(logger.indentationLevel, 1)
        logger.outdent()
        XCTAssertEqual(logger.indentationLevel, 0)
    }

    func testIndentedOutput() {
        var logger = Logger(outputFile: stdout)
        logger.outputHandler = { bytes, file in
            XCTAssertEqual(String(cString: bytes), "  Foo\n")
            return 0
        }
        logger.indent()
        logger.log("Foo")

        logger.outputHandler = { bytes, file in
            XCTAssertEqual(String(cString: bytes), "    Bar\n")
            return 0
        }
        logger.indent()
        logger.log("Bar")

        logger.outputHandler = { bytes, file in
            XCTAssertEqual(String(cString: bytes), "      Baz\n")
            return 0
        }
        logger.indent()
        logger.log("Baz")

        logger.outputHandler = { bytes, file in
            XCTAssertEqual(String(cString: bytes), "    Bax\n")
            return 0
        }
        logger.outdent()
        logger.log("Bax")
    }

    static var allTests = [
        ("testStandardOutput", testStandardOutput),
        ("testStandardError", testStandardError),
        ("testArray", testArray),
        ("testIndent", testIndent),
        ("testOutdent", testOutdent),
        ("testIndentationStep", testIndentationStep),
        ("testIndentedOutput", testIndentedOutput)
    ]
}
