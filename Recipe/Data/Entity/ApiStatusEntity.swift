//
//  ApiStatusEntity.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/08/01.
//

import Foundation

struct ApiStatusEntity: Codable {
    var status: Int?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}

struct ApiResultEntity: Codable {
    var result: Int?
    var message: String?
}

enum ApiErrorType: Error {
    case errorWithMessage(String?)
    case common(Int?)
    case network
    case loginCheckUnauthorized
    case loginCheckAnother(Int?)
    case parsingJson
    case error400
    case error403
    case error404
    case error500
    case error503
    case unknown

    var errorDescription: String? {
        if case .errorWithMessage(let errorDesc) = self {
            return errorDesc
        } else if case .loginCheckUnauthorized = self {
            return "Login check error"
        } else if case .loginCheckAnother(let statusCode) = self {
            return "Login check error: \(statusCode ?? 0)"
        } else {
            return nil
        }
    }
}
