//
//  ProcessResult.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/08/02.
//

import Foundation

enum ProcessResult<T>{
    case success(data: T)
    case failure(message: String?)
}
