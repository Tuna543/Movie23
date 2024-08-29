//
//  APIClientImp.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

class APIClientImp: APIClient {
    func get<T: Decodable> (url: URL) async throws -> T {
        return try await request(url: url, method: "GET")
    }
    
    func post<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        return try await request(url: url, method: "POST", body: bodyData)
    }
    
    func put<T: Decodable, U: Encodable>(url: URL, body: U) async throws -> T {
        let bodyData = try JSONEncoder().encode(body)
        return try await request(url: url, method: "PUT", body: bodyData)
    }
    
    func delete<T: Decodable>(url: URL) async throws -> T {
        return try await request(url: url, method: "DELETE")
    }
    
    
    private func request<T: Decodable>(url: URL, method: String, body: Data? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body
        }
        
        logRequest(url: url, method: method, body: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        logResponse(data: data, response: response)
        
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw APIClientError.invalidData
        }
        
        let decodedObject = try JSONDecoder().decode(T.self, from: data)
        return decodedObject
    }
    
    private func logRequest(url: URL, method: String, body: Data?) {
        print("Request URL: \(url)")
        print("HTTP Method: \(method)")
        if let body = body {
            if let jsonObject = try? JSONSerialization.jsonObject(with: body, options: []),
               let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let jsonString = String(data: prettyPrintedData, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            } else if let jsonString = String(data: body, encoding: .utf8) {
                print("Request Body: \(jsonString)")
            }
        }
    }
    
    private func logResponse(data: Data?, response: URLResponse?) {
        if let data = data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let jsonString = String(data: prettyPrintedData, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            } else if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
        }
    }
}
