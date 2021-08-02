//
//  Repository.swift
//  recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/27.
//

import Foundation
import Moya
import RxSwift

class Repository {
    let recipe = RecipeRepository()
}

extension PrimitiveSequence where Trait == SingleTrait, Element: Response {
    // if we want to show any view based on the response
    fileprivate func checkError(statusCode: Int, errorHandling: Bool = true) -> (ApiErrorType) {
        switch statusCode {
        case 400:
//            if errorHandling { NoNetworkView.show(.badRequest) }
            return .error400
        case 401:
//            if errorHandling { NoNetworkView.show(.unauthorized) }
            return .loginCheckUnauthorized
        case 403:
//            if errorHandling { NoNetworkView.show(.forbidden) }
            return .error403
        case 404:
//            if errorHandling { NoNetworkView.show(.notFound) }
            return .error404
        case 500:
//            if errorHandling { NoNetworkView.show(.serverError) }
            return .error500
        case 503:
//            if errorHandling { NoNetworkView.show(.timeout) }
            return .error503
        default:
//            if errorHandling { NoNetworkView.show(.noInternet) }
            return .unknown
        }
    }

    func parseWithErrorHandling<T>(type: T.Type) -> Single<Result<T, ApiErrorType>> where T: Decodable {
        return self.map { response -> Result<T, ApiErrorType> in
            switch response.statusCode {
            case 200...299:
                do {
                    return .success(try response.map(type))
                } catch {
                    return .failure(.parsingJson)
                }
            default:
                return .failure(checkError(statusCode: response.statusCode))
            }
        }
        .catchError { _ in
            return .just(.failure(.network))
        }
    }

    func withErrorHandling() -> Single<Result<Void, ApiErrorType>> {
        return self.map { response -> Result<Void, ApiErrorType> in
            switch response.statusCode {
            case 200...299:
                return .success(())
            default:
                return .failure(checkError(statusCode: response.statusCode))
            }
        }
        .catchError { _ in
            return .just(.failure(.network))
        }
    }

    func withoutErrorHandling() -> Single<Result<Void, ApiErrorType>> {
        return self.map { response -> Result<Void, ApiErrorType> in
            switch response.statusCode {
            case 200...299:
                return .success(())
            default:
                return .failure(checkError(statusCode: response.statusCode, errorHandling: false))
            }
        }
        .catchError { _ in
            .just(.failure(.network))
        }
    }
}
