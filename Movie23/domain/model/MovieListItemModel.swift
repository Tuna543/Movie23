//
//  MovieListItemModel.swift
//  Movie23
//
//  Created by BS00880 on 1/7/24.
//

import Foundation


struct MovieListItemModel: Identifiable, Codable {
    var id: Int
    var title: String
    var poster: String
    var backgroundImage: String
    var rating: Double
    var releaseYear: Int
    var mpaRating: String
    var duration: String
    var genre: [String]
    var isFavourite: Bool
    
    init(
        id: Int,
        title: String,
        poster: String,
        backgroundImage: String,
        rating: Double,
        releaseYear: Int,
        mpaRating: String,
        duration: String,
        genre: [String],
        isFavourite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.poster = poster
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.releaseYear = releaseYear
        self.mpaRating = mpaRating
        self.duration = duration
        self.genre = genre
        self.isFavourite = isFavourite
    }
    
    static func fromMovie(movie: MovieListResponse.Movie, isFavourite: Bool = false) -> MovieListItemModel {
        return MovieListItemModel(
            id: movie.id,
            title: movie.title,
            poster: movie.largeCoverImage,
            backgroundImage: movie.backgroundImage,
            rating: movie.rating,
            releaseYear: movie.year,
            mpaRating: movie.mpaRating,
            duration: convertMinutesToHoursAndMinutes(minutes: movie.runtime),
            genre: movie.genres ?? [""],
            isFavourite: isFavourite
        )
    }

}
