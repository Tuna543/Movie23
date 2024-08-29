//
//  BaseResponse.swift
//  Movie23
//
//  Created by BS00880 on 28/6/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
//    struct Data : Codable {
//        let movies : [Movie]
//    }
    let status : String
    let statusMessage : String
    let data : T
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusMessage = "status_message"
        case data
    }
}
