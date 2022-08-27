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

    public var value: AnyCodable

    /// Currently using unix timestamp(seconds) for default date encoding/decoding
    /// You can pass decoder object to parse custom date types or other types
    public init(_ data: Data, decoder: JSONDecoder = DefaultJsonDecoder()) throws {
        let object: AnyCodable = try DefaultJsonDecoder().decode(AnyCodable.self, from: data)
        self.value = object
    }

    public init(_ string: String, decoder: JSONDecoder = DefaultJsonDecoder()) throws {
        guard let data = string.data(using: .utf8) else {
            throw JSONError.notJsonString
        }
        try self.init(data, decoder: decoder)
    }

    public init(value: AnyCodable) {
        self.value = value
    }

    // subscript to get item from array
    subscript(index: Int) -> AnyCodable {
        get {
            guard let array = value.value as? [AnyCodable] else {
                return nil
            }
            return array[index]
        }
        set(newValue) {
            guard var array = value.value as? [AnyCodable] else {
                return
            }
            array[index] = newValue
            self.value = .init(array)
        }
    }

    subscript(key: AnyHashable) -> AnyCodable {
        get {
            guard let map = value.value as? [AnyHashable: AnyCodable], let value = map[key] else {
                return nil
            }
            return value
        }
        set(newValue) {
            guard var map = value.value as? [AnyHashable: AnyCodable] else {
                return
            }
            map[key] = newValue
            self.value = .init(map)
        }
    }
}

/// Decoding or parsing as JSON
extension JSON {
    public func asData(encoder: JSONEncoder = DefaultJsonEncoder())-> Data? {
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
    public mutating func append(_ item: AnyCodable) throws {
        guard var array = value.value as? [AnyCodable] else {
            throw JSONError.typeMismatch
        }
        array.append(item)
        self.value = .init(array)
    }
    public mutating func insert(_ item: AnyCodable, index: Int) throws {
        guard var array = value.value as? [AnyCodable] else {
            throw JSONError.typeMismatch
        }
        array.insert(item, at: index)
        self.value = .init(array)
    }
    public mutating func add(_ item: AnyCodable, key: AnyHashable) throws {
        guard var map = value.value as? [AnyHashable: AnyCodable] else {
            throw JSONError.typeMismatch
        }
        map[key] = item
        self.value = .init(map)
    }
}

