//
//  RecipeApiDefinition.swift
//  recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/27.
//

import Foundation
import Moya

enum RecipeApiDefinition {
    case getList
}

extension RecipeApiDefinition: TargetType, MainApi {
    
    var path: String {
        switch self {
        case .getList:
            return "/videos_sample.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getList:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getList:
            return .requestPlain
        }
    }
}
