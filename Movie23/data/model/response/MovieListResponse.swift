//
//  MovieListResponse.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

struct MovieListResponse: Codable {
    
    let movieCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movieCount = "movie_count"
        case movies
    }
    
    struct Movie: Codable {
        let id : Int
        let title : String
        let year : Int
        let rating : Double
        let runtime : Int
        let genres : [String]?
        let descriptionFull : String
        let backgroundImage : String
        let largeCoverImage :  String
        let mpaRating: String
//        let cast: [Cast]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case year
            case rating
            case runtime
            case genres
            case descriptionFull = "description_full"
            case backgroundImage = "background_image"
            case largeCoverImage = "large_cover_image"
            case mpaRating = "mpa_rating"
        }
    
    }
}
