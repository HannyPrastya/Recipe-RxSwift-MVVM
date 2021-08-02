//
//  RecipeRepository.swift
//  recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/27.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

class RecipeRepository {
    private let provider: MoyaProvider<RecipeApiDefinition>
    
    init(provider: MoyaProvider<RecipeApiDefinition> = MoyaProvider<RecipeApiDefinition>()) {
        self.provider = provider
    }

    private let disposeBag = DisposeBag()

    func getRecipeList() -> Single<Result<RecipeListEntity, ApiErrorType>> {
        self.provider.rx
            .request(.getList)
            .parseWithErrorHandling(type: RecipeListEntity.self)
    }
}
