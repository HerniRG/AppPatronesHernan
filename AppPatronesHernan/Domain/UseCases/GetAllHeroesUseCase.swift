//
//  GetAllHeroesUseCase.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Get All Heroes Use Case Contract
protocol GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[Hero], Error>) -> Void)
}

// MARK: - Get All Heroes Use Case Implementation
final class GetAllHeroesUseCase: GetAllHeroesUseCaseContract {
    
    // Ejecuta la solicitud para obtener todos los héroes
    func execute(completion: @escaping (Result<[Hero], any Error>) -> Void) {
        GetHeroesAPIRequest(name: "")
            .perform { result in
                do {
                    try completion(.success(result.get()))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
