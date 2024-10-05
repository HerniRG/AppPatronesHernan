//
//  GetHeroesAPIRequest.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Get Heroes API Request
struct GetHeroesAPIRequest: APIRequest {
    typealias Response = [Hero]
    
    let path: String = "/api/heros/all"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    // Inicializa el request con un nombre opcional
    init(name: String?) {
        body = RequestEntity(name: name ?? "")
    }
}

// MARK: - Request Entity (Encodable)
private extension GetHeroesAPIRequest {
    struct RequestEntity: Encodable {
        let name: String
    }
}
