//
//  RecipeListEntity.swift
//  recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/27.
//

import Foundation

// MARK: - RecipeListResponse
struct RecipeListResponse: Codable {
    let data: [RecipeEntity]
}

// MARK: - RecipeEntity
struct RecipeEntity: Codable {
    let id: String?
    let type: TypeEnum?
    let attributes: Attributes?
}

// MARK: - Attributes
struct Attributes: Codable {
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
