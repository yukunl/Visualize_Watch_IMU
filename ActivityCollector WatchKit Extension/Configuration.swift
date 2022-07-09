//
//  Configuration.swift
//  ActivityCollector WatchKit Extension
//
//  Created by Yukun Li on 5/11/22.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var publicIP: String {
        return try! Configuration.value(for: "PUBLIC_IP")
    }
    static var portNumber: String {
        return try! Configuration.value(for: "PORT_NUMBER")
    }
    
}
