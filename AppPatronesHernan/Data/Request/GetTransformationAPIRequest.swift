//
//  GetTransformationAPIRequest.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import Foundation

// MARK: - Get Transformations API Request
struct GetTransformationsAPIRequest: APIRequest {
    typealias Response = [Transformation]
    
    let path: String = "/api/heros/tranformations"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    // Inicializa el request con el ID del héroe
    init(heroId: String) {
        body = RequestEntity(id: heroId)
    }
}

// MARK: - Request Entity (Encodable)
private extension GetTransformationsAPIRequest {
    struct RequestEntity: Encodable {
        let id: String
    }
}
