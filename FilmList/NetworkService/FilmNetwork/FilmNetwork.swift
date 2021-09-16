//
//  FilmNetwork.swift
//  FilmList
//
//  Created by Nghiêm Huy on 16/09/2021.
//

import Foundation

protocol FilmNetwork {
    func getSearchFilm(page: Int, keySearch: String?,completed: @escaping (Result<[Film], Error>) -> Void)
    func getDetailFilm(id: String?, completed: @escaping (Result<Film, Error>) -> Void)
}

struct DefaultFilmNetwork: FilmNetwork {
    
    var dispatcher: Dispatcher = DefaultJSONDispatcher(host: "http://www.omdbapi.com/")
    
    func getSearchFilm(page: Int,keySearch: String?, completed: @escaping (Result<[Film], Error>) -> Void) {
        self.dispatcher.fetch(request: GetSearchFilmRequest(page: page, keySearch: keySearch), handler: GetSearchFilmReponse(), completed: completed)
    }
    
    func getDetailFilm(id: String?, completed: @escaping (Result<Film, Error>) -> Void) {
        self.dispatcher.fetch(request: GetDetailFilmRequest(id: id), handler: GetDetailFilmResponse(), completed: completed)
    }
    
}
