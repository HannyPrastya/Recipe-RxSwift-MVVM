//
//  Recipe.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/31.
//

import Foundation

struct Recipe {
    var id: String
    var type: SourceType
    var title: String
    var thumbnail: String
    var isFavorited: Bool
    var sortIndex: Int
    
    static func fromEntity(entity: RecipeEntity) -> Recipe {
        return Recipe(
            id: entity.id ?? "",
            type: SourceType(rawValue: entity.type?.rawValue ?? "unknown") ?? .unknown,
            title: entity.attributes?.title ?? "",
            thumbnail: entity.attributes?.thumbnailSquareURL ?? "",
            isFavorited: false,
            sortIndex: 0
        )
    }
}

enum SourceType: String {
    case videos = "videos"
    case unknown = "unknown"
}
