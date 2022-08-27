import XCTest
@testable import JSON

final class JSONTests: XCTestCase {

    func testMap() throws {
        let jsonString =
        """
        { "1" : "Hola" }
        """
        var json = try JSON(string: jsonString)
        let value = json["1"] as? String
        XCTAssert(value == "Hola")

        try json.insert("test", key: "2")
        let value2 = json["2"] as? String
        XCTAssert(value2 == "test")
    }

    func testArray() throws {
        let jsonString =
        """
        [ "Hola" ]
        """
        var json = try JSON(string: jsonString)
        XCTAssertNotNil(json[0] as? String == "Hola")

        try json.append("test")
        XCTAssert(json[1] as? String == "test")
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
