//
//  APIErrorResponse.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

struct APIErrorResponse: Error, Equatable {
    let url: String
    let statusCode: Int
    let data: Data?
    let message: String
    
    init(url: String, statusCode: Int, data: Data? = nil, message: String) {
        self.url = url
        self.statusCode = statusCode
        self.data = data
        self.message = message
    }
}

extension APIErrorResponse {
    static func network(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -1, message: "Network connection error")
    }
    
    static func parseData(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -2, message: "Cannot Parse data")
    }
    
    static func unknown(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -3, message: "Unknown error")
    }
    
    static func empty(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -4, message: "Empty response")
    }
    
    static func malformedURL(_ url: String) -> APIErrorResponse {
        APIErrorResponse(url: url, statusCode: -5, message: "Can't generate the Url")
    }
}
