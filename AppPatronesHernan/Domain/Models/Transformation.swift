//
//  Transformation.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

// MARK: - Transformation Model
struct Transformation: Codable {
    let id: String
    let name: String
    let description: String
    let photo: String
    let hero: HeroId

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case photo
        case hero
    }
}

// MARK: - HeroId Model (Simplificado)
struct HeroId: Codable, Hashable {
    let id: String
}
