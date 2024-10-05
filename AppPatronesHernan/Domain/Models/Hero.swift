//
//  Hero.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

// MARK: - Hero Model
struct Hero: Equatable, Codable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
    
    // Mapeo de los nombres de las claves cuando se codifican/decodifican
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case photo
        case favorite
    }
}
