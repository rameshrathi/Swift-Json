//
//  Extensions.swift
//  
//
//  Created by ramesh on 26/08/22.
//

import Foundation

public enum JSONError: Error {
    case typeMismatch
    case notJSONString
}

public class DefaultJSONDecoder: JSONDecoder {
    public override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
        dateDecodingStrategy = .secondsSince1970
    }
}

public class DefaultJSONEncoder: JSONEncoder {
    public override init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
        dateEncodingStrategy = .secondsSince1970
    }
}

