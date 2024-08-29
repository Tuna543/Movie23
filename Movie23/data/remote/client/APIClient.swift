//
//  APIClient.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

protocol APIClient {
    func get<T: Decodable> (url: URL) async throws -> T
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T
    func put<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T
    func delete<T: Decodable>(url: URL) async throws -> T
}
