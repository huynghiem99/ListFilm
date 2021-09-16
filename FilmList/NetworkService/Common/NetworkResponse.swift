//
//  NetworkResponse.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/21.
//

import Foundation
import SwiftyJSON

protocol NetworkResponse {
    
    associatedtype Resource
    
    func map(data: Data, statusCode: Int, url: URL) -> Result<Resource, Error>
}

extension NetworkResponse {
    func json(from data: Data?, statusCode: Int) -> JSON? {
        guard let data = data, statusCode >= 200 && statusCode < 400 else { return nil }
        return try? JSON(data: data)
    }
}
