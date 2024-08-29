//
//  User.swift
//  Movie23
//
//  Created by BS00880 on 21/6/24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let userName: String
    let email: String
//    let password: String
    var movies : [MovieListItemModel]?
//    static var userShowForTest = User(id: "10", userName: "Fairuz Ahmed", email: "fairuz@gmail.com", /*password: "fairuz",*/ movies: MovieDetailsResponse.Movie.movieArrayShowForTest)
}
