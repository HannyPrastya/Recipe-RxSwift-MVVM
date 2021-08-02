//
//  LocalStorageService.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/08/02.
//

import Foundation

class LocalStorageService {
    private let favoriteKey = "RECIPE_FAVORITES"
    private let storage = UserDefaults.standard
    
    public func getFavoriteRecipes() -> [String] {
        let favorites: [String] = self.storage.object(forKey: favoriteKey) as? [String] ?? []
        return favorites
    }
    
    public func setFavoriteRecipes(_ recipes: [String] ) {
        self.storage.setValue(recipes, forKey: favoriteKey)
    }
}
