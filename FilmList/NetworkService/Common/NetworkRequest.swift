//
//  NetworkRequest.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/21.
//

import Foundation
import Alamofire

struct BodyRequest {
    var data: Any?
    var encoding: String
}

protocol NetworkRequest {
    var path: String { get }
    
    var method: String { get }
    
    var headers: [String: String]? { get }
    
    var parameters: [String: Any]? { get }
    
    var body: BodyRequest? { get }
}

extension NetworkRequest {
    var method: String { HTTPMethod.get.rawValue }
    
    var parameters: [String: Any]? { nil }
    
    var headers: [String: String]? { nil }
    
    var body: BodyRequest? { nil }
}
