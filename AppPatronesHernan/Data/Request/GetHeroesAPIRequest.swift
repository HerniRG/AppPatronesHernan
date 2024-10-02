//
//  GetHeroesAPIRequest.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

struct GetHeroesAPIRequest: APIRequest {
    typealias Response = [Hero]
    
    let path: String = "/api/heros/all"
    let method: HTTPMethod = .POST
    let body: (any Encodable)?
    
    init(name: String?) {
        body = RequestEntity(name: name ?? "")
    }
}

private extension GetHeroesAPIRequest {
    struct RequestEntity: Encodable {
        let name: String
    }
}
