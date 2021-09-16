//
//  Error.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import Foundation

struct NetworkError: Error {
    var statusCode: Int
    var url: URL
    var userInfo: [String: Any]?
}
