import XCTest
@testable import JSON

final class JSONTests: XCTestCase {
    func testExample() throws {
        let jsonString =
        """
        { "1" : "Hola" }
        """
        let json = try JSON(jsonString)
        print(json.value.description)
    }
}
