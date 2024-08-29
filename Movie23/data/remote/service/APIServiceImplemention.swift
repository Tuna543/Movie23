//
//  APIServiceImplemention.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

class APIServiceImplemention: APIService {
    private let apiClient: APIClient
    private var baseURL = URL(string: "https://yts.mx/api/v2")!
    
    init(apiClient: APIClient, baseURL: URL? = nil) {
        self.apiClient = apiClient
        if let baseURL = baseURL {
            self.baseURL = baseURL
        }
    }
    
    func getMovieList() async throws -> BaseResponse<MovieListResponse> {
        let url = baseURL.appendingPathComponent("/list_movies.json")
        let response: BaseResponse<MovieListResponse> = try await apiClient.get(url: url)
        return response
    }
    
    func getMovieListByQuery(query: String) async throws -> BaseResponse<MovieListResponse> {
        var components = URLComponents(url: baseURL.appendingPathComponent("/list_movies.json"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "query_term", value: query)]
        let url = components.url!
        let response: BaseResponse<MovieListResponse> = try await apiClient.get(url: url)
        return response
    }
    
    func getMovieListByFilter(query: String, sortBy: String? = nil, orderBy: String? = nil, genre: [String]? = nil) async throws -> BaseResponse<MovieListResponse> {
        var components = URLComponents(url: baseURL.appendingPathComponent("/list_movies.json"), resolvingAgainstBaseURL: false)!
        
        var queryItems = [URLQueryItem(name: "query_term", value: query)]
        
        if let sortBy = sortBy {
            queryItems.append(URLQueryItem(name: "sort_by", value: sortBy))
        }
        if let orderBy = orderBy {
            queryItems.append(URLQueryItem(name: "order_by", value: orderBy))
        }
        if let genres = genre {
            for genre in genres {
                queryItems.append(URLQueryItem(name: "genre", value: genre))
            }
        }
        components.queryItems = queryItems
        let url = components.url!
        let response: BaseResponse<MovieListResponse> = try await apiClient.get(url: url)
        return response
    }
    
    func getMovieListByGenre(genre: MovieGenre) async throws -> BaseResponse<MovieListResponse> {
        var components = URLComponents(url: baseURL.appendingPathComponent("/list_movies.json"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "genre", value: genre.toString())]
        let url = components.url!
        let response: BaseResponse<MovieListResponse> = try await apiClient.get(url: url)
        return response
    }
    
    func getMovieDetails(movieId: Int) async throws -> BaseResponse<MovieDetailsResponse> {
        var components = URLComponents(url: baseURL.appendingPathComponent("/movie_details.json"), resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "movie_id", value: "\(movieId)"),
            URLQueryItem(name: "with_cast", value: "true")
        ]
        let url = components.url!
        let response: BaseResponse<MovieDetailsResponse> = try await apiClient.get(url: url)
        return response
//        let url = baseURL.appendingPathComponent("/movie_details.json?movie_id=\(movieId)&with_cast=true")
//        let response: BaseResponse<MovieDetailsResponse> = try await apiClient.get(url: url)
//        return response
    }
}
