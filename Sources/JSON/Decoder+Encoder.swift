//
//  Extensions.swift
//  
//
//  Created by ramesh on 26/08/22.
//

import Foundation

public class DefaultJsonDecoder: JSONDecoder {
    public override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
        dateDecodingStrategy = .secondsSince1970
    }
}

public class DefaultJsonEncoder: JSONEncoder {
    public override init() {
        super.init()
        keyEncodingStrategy = .convertToSnakeCase
        dateEncodingStrategy = .secondsSince1970
    }
}

