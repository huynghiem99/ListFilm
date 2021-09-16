//
//  GetListFilm.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GetSearchFilmRequest: NetworkRequest {
    var path: String { "?apikey=b9bd48a6&type=movie" }
    
    var method: String { HTTPMethod.get.rawValue }
    
    var parameters: Parameters? {
        var params: [String: Any] = ["page": self.page]
        if keySearch != nil {
            params["s"] = keySearch
        }
        return params
    }
    
    var page: Int
    var keySearch: String?
}

struct GetSearchFilmReponse: NetworkResponse {
    func map(data: Data, statusCode: Int, url: URL) -> Result<[Film], Error> {        
        guard let json = self.json(from: data, statusCode: statusCode) else { return .failure(NetworkError.init(statusCode: statusCode, url: url, userInfo: nil)) }
        var listFilms:[Film] = []
        let data = json["Search"]
        if data != JSON.null {
            for filmElement in data.array ?? [] {
                let title = filmElement["Title"].string ?? ""
                let poster = filmElement["Poster"].string ?? ""
                let imdbID = filmElement["imdbID"].string ?? ""
                let film: Film = .init(title: title, poster: poster,imdbID: imdbID)
                listFilms.append(film)
            }
        }
        return .success(listFilms)
    }
}
