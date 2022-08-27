import XCTest
@testable import JSON

final class JSONTests: XCTestCase {

    func testMap() throws {
        let jsonString =
        """
        { "1" : "Hola" }
        """
        var json = try JSON(string: jsonString)
        XCTAssertNotNil(json["1"] == "Hola")

        try json.add("test", key: "1")
        XCTAssert(json["2"] == "test")
    }

    func testArray() throws {
        let jsonString =
        """
        [ "Hola" ]
        """
        var json = try JSON(string: jsonString)
        XCTAssertNotNil(json[0] == "Hola")

        try json.append("test")
        XCTAssert(json[1] == "test")
    }

    func testString() throws {
        let jsonString =
        """
        "Hola"
        """
        let json = try JSON(string: jsonString)
        XCTAssert(json == "Hola")
        let value: String? = try? json.value()
        XCTAssertNotNil(value)
    }

    func testNumber() throws {
        let jsonString =
        """
        1213
        """
        let json = try JSON(string: jsonString)
        let value: Int? = try? json.value()
        XCTAssertNotNil(value)
    }
}
