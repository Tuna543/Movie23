//
//  MovieListViewModel.swift
//  Movie23
//
//  Created by BS00880 on 1/7/24.
//

import Foundation

@MainActor
class MovieListViewModel {
//    var movieList: [MovieListItemModel] = []
    var movieList: [MovieListItemModel] = [] {
        didSet {
            self.movieListUpdated?()
        }
    }
    
    var movieListUpdated: (() -> Void)?

    private var movieRepository: MovieRepository
//    private var navigationViewModel: NavigationViewModel
    
    init(
        movieRepository: MovieRepository//,
//        navigationViewModel: NavigationViewModel
    ) {
        self.movieRepository = movieRepository
//        self.navigationViewModel = navigationViewModel
        fetchMovieList()
    }
    
    private func fetchMovieList() {
        Task {
            do {
                movieList = try await movieRepository.getMovieList()
                print("Movie List: \(movieList)")
            } catch {
                print("(In Movie List View Model) Error: \(error)")
            }
        }
    }
    
//    func onRefresh() {
//        fetchMovieList()
//    }
    
    func onClickedMovieItem(movieId: Int) {
        print("Movie clicked: \(movieId)")
//        navigationViewModel.navigateTo(screen: .movieDetails(id: movieId))
    }
}
