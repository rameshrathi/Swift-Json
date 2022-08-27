import XCTest
@testable import JSON

final class JSONTests: XCTestCase {

    func testMap() throws {
        let jsonString =
        """
        { "1" : "Hola" }
        """
        let json = try JSON(jsonString)
        XCTAssertNotNil(json["1"]?.asString() == "Hola")

        let updated = try json.setValue("Test", key: "2")
        XCTAssert(updated["2"]?.asString() == "Test")
    }

    func testArray() throws {
        let jsonString =
        """
        [ "Hola" ]
        """
        let json = try JSON(jsonString)
        XCTAssertNotNil(json[0]?.asString() == "Hola")

        let updated = try json.appending("Test")
        XCTAssert(updated[1]?.asString() == "Test")
    }

    func testString() throws {
        let jsonString =
        """
        [ "Hola" ]
        """
        let json = try JSON(jsonString)
        XCTAssert(json.asString() == nil)
        XCTAssert(json[0]?.asString() != nil)
    }

    func testNumber() throws {
        let jsonString =
        """
        { "value": 16615836 }
        """
        let json = try JSON(jsonString)
        XCTAssert(json["value"]?.asInt() != nil)
    }
}
