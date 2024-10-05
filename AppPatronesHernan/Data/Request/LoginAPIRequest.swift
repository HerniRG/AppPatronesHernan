//
//  LoginAPIRequest.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Login API Request
struct LoginAPIRequest: APIRequest {
    typealias Response = Data
    
    let headers: [String: String]
    let method: HTTPMethod = .POST
    let path: String = "/api/auth/login"
    
    // Inicializa la solicitud de login con las credenciales del usuario
    init(credentials: Credentials) {
        let loginData = Data(String(format: "%@:%@", credentials.username, credentials.password).utf8)
        let base64String = loginData.base64EncodedString()
        headers = ["Authorization": "Basic \(base64String)"]
    }
}
