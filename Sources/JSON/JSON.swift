//
// JSON.swift
//

import Foundation

/// Codable related errors
public enum JSONError: Error {
    case notJsonString
    case typeMismatch
}

/// JSON parsing and editing using `JSON` object
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

    // subscript to get item from array
    subscript(index: Int) -> JSON? {
        guard let array = value.value as? [Any] else {
            return nil
        }
        return JSON(value: AnyCodable(array[index]))
    }

    subscript(key: AnyHashable) -> JSON? {
        guard let map = value.value as? [AnyHashable: Any], let value = map[key] else {
            return nil
        }
        return JSON(value: AnyCodable(value))
    }
}

/// Decoding or parsing as JSON
extension JSON {
    public func asData()-> Data? {
        try? DefaultJsonEncoder().encode(value)
    }

    public func asBool() -> Bool? {
        value.value as? Bool
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

    public func asInt() -> Int? {
        value.value as? Int
    }

    public func asUInt() -> UInt? {
        value.value as? UInt
    }

    public func asInt8() -> Int8? {
        value.value as? Int8
    }

    public func asUInt8() -> UInt8? {
        value.value as? UInt8
    }

    public func asInt32() -> Int32? {
        value.value as? Int32
    }

    public func asUInt32() -> UInt32? {
        value.value as? UInt32
    }

    public func asInt64() -> Int64? {
        value.value as? Int64
    }

    public func asUInt64() -> UInt64? {
        value.value as? UInt64
    }
}

extension JSON {
    public func appending(_ item: Any) throws -> JSON {
        guard let array = value.value as? [Any] else {
            throw JSONError.typeMismatch
        }
        return JSON(value: .init(array + [item]))
    }
    public func inserting(_ item: Any, index: Int) throws -> JSON {
        guard var array = value.value as? [Any] else {
            throw JSONError.typeMismatch
        }
        array.insert(item, at: index)
        return JSON(value: .init(array))
    }
    public func setValue(_ item: Any, key: AnyHashable) throws -> JSON {
        guard var map = value.value as? [AnyHashable: Any] else {
            throw JSONError.typeMismatch
        }
        map[key] = item
        return JSON(value: .init(map))
    }
}

