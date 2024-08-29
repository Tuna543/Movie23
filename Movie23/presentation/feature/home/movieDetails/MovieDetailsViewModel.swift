//
//  MovieDetailsViewModel.swift
//  Movie23
//
//  Created by BS00880 on 1/7/24.
//

import Foundation

class MovieDetailsViewModel {
    var movieDetails: MovieDetailsModel? = nil {
        didSet {
            self.movieDetailsUpdated?()
        }
    }
    var movieDetailsUpdated: (() -> Void)?
    private var movieRepository: MovieRepository
    
    init(movieRepositoy: MovieRepository, movieId: Int) {
        self.movieRepository = movieRepositoy
        getMovieDetails(movieId: movieId)
    }
    
    func getMovieDetails(movieId: Int) {
        Task{
            do {
                movieDetails = await try movieRepository.getMovieDetails(movieId: movieId)
            } catch {
                print("Error in fetching movie details \(error)")
            }
        }
    }
}
