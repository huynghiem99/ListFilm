//
//  GetDetailFilm.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GetDetailFilmRequest: NetworkRequest {
    var path: String { "?apikey=b9bd48a6" }
    
    var parameters: Parameters? {
        var params: [String: Any] = [:]
        if id != nil {
            params["i"] = id
        }
        return params
    }
    
    var id: String?
    
    var method: String { HTTPMethod.get.rawValue }

}

struct GetDetailFilmResponse: NetworkResponse {
    func map(data: Data, statusCode: Int, url: URL) -> Result<Film, Error> {
        guard let json = self.json(from: data, statusCode: statusCode) else { return .failure(NetworkError.init(statusCode: statusCode, url: url, userInfo: nil)) }
        var film:Film = Film.init()
        let data = json
        if data != JSON.null {
            let title = data["Title"].string ?? ""
            let poster = data["Poster"].string ?? ""
            let year = data["Year"].string ?? ""
            let runtime = data["Runtime"].string ?? ""
            let genre = data["Genre"].string ?? ""
            let director = data["Director"].string ?? ""
            let writer = data["Writer"].string ?? ""
            let actor = data["Actors"].string ?? ""
            let plot = data["Plot"].string ?? ""
            let imdbVote = data["imdbVotes"].string ?? ""
            let metaScore = data["Metascore"].string ?? ""
            let imdbRating = data["imdbRating"].string ?? ""
            
            film = .init(title: title, year: year, genre: genre, runtime: runtime, rating: nil, plot: plot, poster: poster, director: director, actor: actor, writer: writer, numberReview: imdbVote, popularity: metaScore, imdbRating: imdbRating)
            
        }
        return .success(film)
    }
}
