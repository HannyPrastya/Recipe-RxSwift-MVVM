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
    private let provider = MoyaProvider<RecipeApiDefinition>(
        endpointClosure: { (target: RecipeApiDefinition) -> Endpoint in
            let ep = MoyaProvider.defaultEndpointMapping(for: target)
            return ep
        },
        plugins: [CachePolicyPlugin()]
    )
    private let disposeBag = DisposeBag()

//    // Setting Banner
//    func getSetting() -> Single<Result<TeamSiteSettingEntity, ApiError>> {
//        self.provider.rx
//            .request(.getTeamSiteSetting)
//            .parseWithErrorHandling(type: TeamSiteSettingEntity.self)
//    }
//
//    // Ad Banner
//    func getAdBannerSetting() -> Single<Result<AdBannerSettingEntity, ApiError>> {
//        self.provider.rx
//            .request(.getAdBannerSetting)
//            .parseWithErrorHandling(type: AdBannerSettingEntity.self)
//    }
}
