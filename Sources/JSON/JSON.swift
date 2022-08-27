//
//  JSON.swift
//  
//
//  Created by ramesh on 27/08/22.
//

import Foundation

/// JSON parsing and editing using `JSON` object
/// - Create JSON object from data serialized using utf-8 encoding
/// - Create JSON object from string

@frozen public struct JSON: Codable {

    private var _value: Any

    public init(_ value: Any?) {
        self._value = value ?? ()
    }

    public func value<T>() throws -> T {
        guard let val = _value as? T else {
            throw JSONError.typeMismatch
        }
        return val
    }

    /// Currently using unix timestamp(seconds) for default date encoding/decoding
    /// You can pass decoder object to parse custom date types or other types
    public init(data: Data, decoder: JSONDecoder = DefaultJSONDecoder()) throws {
        let object: JSON = try DefaultJSONDecoder().decode(JSON.self, from: data)
        self._value = object._value
    }

    /// Init from string will decode string it into json object
    ///  To initialize with string value, use - init(value)
    public init(string: String, decoder: JSONDecoder = DefaultJSONDecoder()) throws {
        guard let data = string.data(using: .utf8) else {
            throw JSONError.notJSONString
        }
        try self.init(data: data, decoder: decoder)
    }

    // subscript to get item from array
    subscript(index: Int) -> Any? {
        get {
            guard let array = _value as? [Any] else {
                return nil
            }
            return array[index]
        }
        set(newValue) {
            guard var array = _value as? [Any], let value = newValue else {
                return
            }
            array[index] = value
            self._value = array
        }
    }

    subscript(key: AnyHashable) -> Any? {
        get {
            guard let map = _value as? [AnyHashable: Any], let value = map[key] else {
                return nil
            }
            return value
        }
        set(newValue) {
            guard var map = _value as? [AnyHashable: Any], let value = newValue else {
                return
            }
            map[key] = value
            self._value = map
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.init(Optional<Self>.none)
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([JSON].self) {
            self.init(array.map { $0._value })
        } else if let dictionary = try? container.decode([String: JSON].self) {
            self.init(dictionary.mapValues { $0._value })
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyDecodable value cannot be decoded")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch _value {
        case is Void:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let int8 as Int8:
            try container.encode(int8)
        case let int16 as Int16:
            try container.encode(int16)
        case let int32 as Int32:
            try container.encode(int32)
        case let int64 as Int64:
            try container.encode(int64)
        case let uint as UInt:
            try container.encode(uint)
        case let uint8 as UInt8:
            try container.encode(uint8)
        case let uint16 as UInt16:
            try container.encode(uint16)
        case let uint32 as UInt32:
            try container.encode(uint32)
        case let uint64 as UInt64:
            try container.encode(uint64)
        case let float as Float:
            try container.encode(float)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any?]:
            try container.encode(array.map { JSON($0) })
        case let dictionary as [String: Any?]:
            try container.encode(dictionary.mapValues { JSON($0) })
        case let encodable as Encodable:
            try encodable.encode(to: encoder)
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "AnyEncodable value cannot be encoded")
            throw EncodingError.invalidValue(_value, context)
        }
    }
}

extension JSON {
    public mutating func append(_ item: JSON) throws {
        guard var array = _value as? [Any] else {
            throw JSONError.typeMismatch
        }
        array.append(item._value)
        self = .init(array)
    }
    public mutating func insert(_ item: JSON, index: Int) throws {
        guard var array = _value as? [JSON] else {
            throw JSONError.typeMismatch
        }
        array.insert(item, at: index)
        self = .init(array)
    }
    public mutating func insert(_ item: JSON, key: AnyHashable) throws {
        guard var map = _value as? [AnyHashable: Any] else {
            throw JSONError.typeMismatch
        }
        map[key] = item._value
        self = .init(map)
    }
}

//extension JSON: _AnyEncodable, _AnyDecodable {}

extension JSON: Equatable {
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs._value, rhs._value) {
        case is (Void, Void):
            return true
        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs
        case let (lhs as Int, rhs as Int):
            return lhs == rhs
        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs
        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs
        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs
        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs
        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs
        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs
        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs
        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs
        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs
        case let (lhs as Float, rhs as Float):
            return lhs == rhs
        case let (lhs as Double, rhs as Double):
            return lhs == rhs
        case let (lhs as String, rhs as String):
            return lhs == rhs
        case let (lhs as [String: JSON], rhs as [String: JSON]):
            return lhs == rhs
        case let (lhs as [JSON], rhs as [JSON]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension JSON: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch _value {
        case let value as Bool:
            hasher.combine(value)
        case let value as Int:
            hasher.combine(value)
        case let value as Int8:
            hasher.combine(value)
        case let value as Int16:
            hasher.combine(value)
        case let value as Int32:
            hasher.combine(value)
        case let value as Int64:
            hasher.combine(value)
        case let value as UInt:
            hasher.combine(value)
        case let value as UInt8:
            hasher.combine(value)
        case let value as UInt16:
            hasher.combine(value)
        case let value as UInt32:
            hasher.combine(value)
        case let value as UInt64:
            hasher.combine(value)
        case let value as Float:
            hasher.combine(value)
        case let value as Double:
            hasher.combine(value)
        case let value as String:
            hasher.combine(value)
        case let value as [String: JSON]:
            hasher.combine(value)
        case let value as [JSON]:
            hasher.combine(value)
        default:
            break
        }
    }
}

extension JSON: CustomStringConvertible {
    public var description: String {
        switch _value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: _value)
        }
    }
}

extension JSON: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch _value {
        case let value as CustomDebugStringConvertible:
            return "JSON(\(value.debugDescription))"
        default:
            return "JSON(\(description))"
        }
    }
}

extension JSON: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self._value = ()
    }
}

extension JSON: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Bool
    public init(booleanLiteral value: Bool) {
        self._value = value
    }
}

extension JSON: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    public init(integerLiteral value: Int) {
        self._value = value
    }
}

extension JSON: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
    public init(floatLiteral value: Double) {
        self._value = value
    }
}

extension JSON: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self._value = value
    }
}

extension JSON: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = JSON

    public init(arrayLiteral elements: JSON...) {
        self._value = Array(elements)
    }
}

extension JSON: ExpressibleByDictionaryLiteral {
    public typealias Key = AnyHashable
    public typealias Value = JSON

    public init(dictionaryLiteral elements: (AnyHashable, JSON)...) {
        self._value = Dictionary<Key, Value>(uniqueKeysWithValues: elements)
    }
}
