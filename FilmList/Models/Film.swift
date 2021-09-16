//
//  Film.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import Foundation

struct Film: Decodable {
    var title: String?
    var year: String?
    var genre: String?
    var runtime: String?
    var rating: Ratings?
    var plot: String?
    var poster: String?
    var director: String?
    var actor: String?
    var writer: String?
    var numberReview: String?
    var popularity: String?
    var imdbRating: String?
    var imdbID: String?
}


struct Ratings: Decodable {
    var internetMovieRate: Rate?
    var rottenTomatoRate: Rate?
    var metacriticRate: Rate?
}

struct Rate: Decodable {
    var source: String
    var value: String
}
