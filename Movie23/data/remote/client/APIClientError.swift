//
//  APIClientError.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

enum APIClientError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
