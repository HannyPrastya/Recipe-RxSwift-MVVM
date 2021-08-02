//
//  RecipeListEntity.swift
//  recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/27.
//

import Foundation

// MARK: - RecipeListEntity
struct RecipeListEntity: Codable, Equatable {
    let data: [RecipeEntity]
}

// MARK: - RecipeEntity
struct RecipeEntity: Codable, Equatable {
    let id: String?
    let type: TypeEnum?
    let attributes: Attributes?
}

// MARK: - Attributes
struct Attributes: Codable, Equatable {
    let title: String?
    let thumbnailSquareURL: String?

    enum CodingKeys: String, CodingKey {
        case title
        case thumbnailSquareURL = "thumbnail-square-url"
    }
}

enum TypeEnum: String, Codable {
    case videos = "videos"
}
