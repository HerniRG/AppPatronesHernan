//
//  Hero.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

struct Hero: Equatable, Decodable {
    let identifier: String
    let name: String
    let description: String
    let photo: String
    let favorite: Bool
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case photo
        case favorite
    }
}
