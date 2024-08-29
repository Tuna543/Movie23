//
//  APIService.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

protocol APIService {
    func getMovieList() async throws -> BaseResponse<MovieListResponse>
    func getMovieListByQuery(query: String) async throws -> BaseResponse<MovieListResponse>
    func getMovieListByFilter(query: String, sortBy: String?, orderBy: String?, genre: [String]?) async throws -> BaseResponse<MovieListResponse>
    func getMovieListByGenre(genre: MovieGenre) async throws -> BaseResponse<MovieListResponse>
    func getMovieDetails(movieId: Int) async throws -> BaseResponse<MovieDetailsResponse>
}
