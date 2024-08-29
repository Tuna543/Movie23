//
//  Cast.swift
//  Movie23
//
//  Created by BS00880 on 21/6/24.
//

import Foundation

struct Cast:  Codable/*, Decodable*/ {
//            let imdbCode: String
    let name: String
    let characterName: String
    let urlSmallImage: String?
    
    enum CodingKeys: String, CodingKey {
        case name
//                case imdbCode = "imdb_code"
        case characterName = "character_name"
        case urlSmallImage = "url_small_image"
    }
    
    static var castForTest = Cast(name: "", characterName: "", urlSmallImage: "cast_dummy_img")
    static var ifNoCastDataAvailable = Cast(name: "No Data", characterName: "No Data", urlSmallImage: "cast_dummy_img")
    
    
}
