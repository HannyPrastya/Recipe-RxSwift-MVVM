//
//  RecipeRepositoryTests.swift
//  RecipeTests
//
//  Created by Hanny Prastya Hariyadi on 2021/08/02.
//

import XCTest
import Quick
import Nimble
import Moya
import RxBlocking
@testable import Recipe

class RecipeRepositoryTests: QuickSpec {
    override func spec() {
        describe("Get recipes") {
            it("will get one recipe with success response") {
                let recipeRepository = RecipeRepository(provider: MoyaProvider<RecipeApiDefinition>(stubClosure: MoyaProvider.immediatelyStub))
                let recipes: RecipeListEntity = RecipeListEntity(data: [RecipeEntity(id: "1", type: .videos, attributes: Attributes(title: "test", thumbnailSquareURL: "image"))])
                let result: Result<RecipeListEntity, ApiErrorType> = try! recipeRepository.getRecipeList().toBlocking().first()!
                switch result {
                    case .success(let response):
                        expect(response).to(equal(recipes))
                    break
                    case .failure(_):
                    break
                }
            }
        }
    }
}

