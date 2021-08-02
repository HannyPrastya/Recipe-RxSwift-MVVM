//
//  RecipeViewModel.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/31.
//

import Foundation
import RxCocoa
import RxSwift

class RecipeViewModel {
    private let repo = Repository()
    private let storage = LocalStorageService()
    
    private var _selectedRecipe = PublishRelay<Recipe?>()
    var selectedRecipe: Driver<Recipe?> { return self._selectedRecipe.asDriver(onErrorJustReturn: nil) }
    
    private var _recipes = BehaviorRelay<[Recipe]>(value: [])
    var recipes: Observable<[Recipe]> { return self._recipes.asObservable() }
    
    private var _favoritedRecipes = BehaviorRelay<[String]>(value: [])
    var favoritedRecipes: Observable<[String]> { return self._favoritedRecipes.asObservable() }
    
    private var _addFavoriteResult = PublishRelay<ProcessResult<Recipe>>()
    var addFavoriteResult: Driver<ProcessResult<Recipe>> { return self._addFavoriteResult.asDriver(onErrorJustReturn: .failure(message: nil)) }
    
    let disposeBag = DisposeBag()
    
    public func refresh() {
        fetchFavoritedRecipes()
        fetchRecipeList()
    }
    
    public func toggleFavoriteRecipe(_ recipe: Recipe){
        if recipe.isFavorited {
            removeRecipeToFavoriteList(recipe)
        } else {
            addRecipeToFavoriteList(recipe)
        }
    }
    
    public func selectRecipe(_ recipe: Recipe){
        self._selectedRecipe.accept(recipe)
    }
    
    private func addRecipeToFavoriteList(_ recipe: Recipe){
        // if we need to call an API, we can call any observer here
        var favorites: [String] = _favoritedRecipes.value
        
        if !favorites.contains(recipe.id) {
            favorites.append(recipe.id)
            self.storage.setFavoriteRecipes(favorites)
            self._favoritedRecipes.accept(favorites)
            self._addFavoriteResult.accept(.success(data: recipe))
        }
    }
    
    private func removeRecipeToFavoriteList(_ recipe: Recipe){
        // if we need to call an API, we can call any observer here
        var favorites: [String] = _favoritedRecipes.value
        
        if let index = favorites.firstIndex(of: recipe.id) {
            favorites.remove(at: index)
            self.storage.setFavoriteRecipes(favorites)
            self._favoritedRecipes.accept(favorites)
        }
    }
    
    private func fetchRecipeList() {
        self.repo.recipe.getRecipeList()
            .subscribe(onSuccess: { [weak self] result in
                switch result {
                case .success(let entity):
                    let recipes = entity.data.map{ Recipe.fromEntity(entity: $0) }
                    self?._recipes.accept(recipes)
                case .failure:
                    self?._recipes.accept([])
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func fetchFavoritedRecipes() {
        let favorites = storage.getFavoriteRecipes()
        self._favoritedRecipes.accept(favorites)
    }
}
