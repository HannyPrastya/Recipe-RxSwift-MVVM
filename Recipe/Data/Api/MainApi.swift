//
//  MainApi.swift
//  recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/27.
//

import Foundation
import Moya

protocol MainApi: TargetType {}

protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

final class CachePolicyPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePolicyGettable = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }
        return request
    }
}

extension MainApi {
    var baseURL: URL {
        return URL(string: "https://s3-ap-northeast-1.amazonaws.com/data.kurashiru.com")!
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
