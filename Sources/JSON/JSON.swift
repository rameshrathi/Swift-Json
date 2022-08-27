//
// JSON.swift
//

import Foundation

/// Codable related errors
public enum JSONError: Error {
    case notJsonString
    case decodingError(String)
    case encodingError(String)
    case someFieldsMissing
}

/// JSON Manipulation Object, Parsing and editing json is very easy in swift now
/// Use DSL like methods to edit/change data in the json object
/// - Create JSON object from data serialized using utf-8 encoding
/// - Create JSON object from string

public struct JSON {

    let value: AnyCodable

    public init(_ data: Data) throws {
        let object: AnyCodable = try DefaultJsonDecoder().decode(AnyCodable.self, from: data)
        self.value = object
    }

    public init(_ string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw JSONError.notJsonString
        }
        try self.init(data)
    }

    public init(value: AnyCodable) {
        self.value = value
    }

    // subscript
//    subscript(index: Int) -> JSON? {
//        get {
//
//        }
//        set(newValue) {
//
//        }
//    }
}

/// Decoding or parsing as JSON
extension JSON {
    public func asData()-> Data? {
        try? DefaultJsonEncoder().encode(value)
    }

    public func asInt() -> Int? {
        value.value as? Int
    }

    public func asString() -> String? {
        value.value as? String
    }

    public func asDouble() -> Double? {
        value.value as? Double
    }

    public func asFloat() -> CGFloat? {
        value.value as? CGFloat
    }

    public func asUInt() -> UInt? {
        value.value as? UInt
    }
}
