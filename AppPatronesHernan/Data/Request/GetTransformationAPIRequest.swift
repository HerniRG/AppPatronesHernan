//
//  GetTransformationAPIRequest.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import Foundation

struct GetTransformationsAPIRequest: APIRequest {
    typealias Response = [Transformation]
    
    let path: String = "/api/heros/tranformations"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    init(heroId: String) {
        body = RequestEntity(id: heroId)
    }
}

private extension GetTransformationsAPIRequest {
    struct RequestEntity: Encodable {
        let id: String
    }
}
