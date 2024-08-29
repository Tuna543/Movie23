//
//  MovieRepositoryImp.swift
//  Movie23
//
//  Created by BS00880 on 1/7/24.
//

import Foundation

class MovieRepositoryImpl: MovieRepository {
    
    
    private let apiService: APIService
//    private let databaseService: DatabaseService
    
    init(apiService: APIService/*, databaseService: DatabaseService*/) {
        self.apiService = apiService
//        self.databaseService = databaseService
    }
    
    func getMovieList() async throws -> [MovieListItemModel] {
        let response: BaseResponse<MovieListResponse> = try await apiService.getMovieList()
//        let favouriteMovieIds = try await getFavouriteMovieIds()
        return response.data.movies.map{ movie in
            MovieListItemModel.fromMovie(
                movie: movie//,
//                isFavourite: favouriteMovieIds.contains(movie.id)
            )
        }
    }
    
    func getMovieListByQuery(query: String) async throws -> [MovieListItemModel] {
           let response = try await apiService.getMovieListByQuery(query: query)
           
//           let favouriteMovieIds = try await getFavouriteMovieIds()
           return response.data.movies.map{ movie in
               MovieListItemModel.fromMovie(
                   movie: movie//,
//                   isFavourite: favouriteMovieIds.contains(movie.id)
               )
           }
       }
    
    func getMovieListByFilter(query: String, sortBy: String? = nil, orderBy: String? = nil, genre: [String]? = nil) async throws -> [MovieListItemModel] {
        let response = try await apiService.getMovieListByFilter(query: query, sortBy: sortBy, orderBy: orderBy, genre: genre)
//        let favouriteMovieIds = try await getFavouriteMovieIds()
        return response.data.movies.map{ movie in
            MovieListItemModel.fromMovie(
                movie: movie//,
//                isFavourite: favouriteMovieIds.contains(movie.id)
            )
        }
    }
    
    func getMovieDetails(movieId: Int) async throws -> MovieDetailsModel {
        let response = try await apiService.getMovieDetails(movieId: movieId)
        
//        let favouriteMovieIds = try await getFavouriteMovieIds()
        return MovieDetailsModel.fromMovie(
            movie: response.data.movie
        )
    }
    
    func getMovieListByGenre(genre: MovieGenre) async throws -> [MovieListItemModel] {
        let response = try await apiService.getMovieListByGenre(genre: genre)
        
        //            let favouriteMovieIds = try await getFavouriteMovieIds()
        return response.data.movies.map{ movie in
            MovieListItemModel.fromMovie(
                movie: movie//,
                //                    isFavourite: favouriteMovieIds.contains(movie.id)
            )
        }
    }
    
//    func getFavoriteMovies() async throws -> [MovieListItemModel] {
//        let favouriteMovieList: [FavouriteMovieDatabaseModel] = try await databaseService.getFavouriteMovieList()
//        return favouriteMovieList.map{MovieListItemModel.fromFavouriteMovie(favouriteMovie: $0)}
//    }
//    
//    func addFavoriteMovie(movie: MovieListItemModel) async throws -> Void {
//        try await databaseService.addFavouriteMovie(movie: movie.toFavouriteMovie())
//    }
//    
//    func removeFavoriteMovie(movie: MovieListItemModel) async throws -> Void {
//        try await databaseService.removeFavouriteMovie(movieId: movie.id)
//    }
//    
//    private func getFavouriteMovieIds() async throws -> [Int] {
//        let favouriteMovieList: [FavouriteMovieDatabaseModel] = try await databaseService.getFavouriteMovieList()
//        return favouriteMovieList.map{$0.id}
//    }
}
