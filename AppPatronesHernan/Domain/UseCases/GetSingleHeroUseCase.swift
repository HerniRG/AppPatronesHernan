//
//  GetSingleHeroUseCase.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

import Foundation

// MARK: - Get Single Hero Use Case Contract
protocol GetSingleHeroUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void)
}

// MARK: - Get Single Hero Use Case Implementation
final class GetSingleHeroUseCase: GetSingleHeroUseCaseContract {
    private let getAllHeroesUseCase: GetAllHeroesUseCaseContract

    // Inicializa con el caso de uso para obtener todos los héroes
    init(getAllHeroesUseCase: GetAllHeroesUseCaseContract = GetAllHeroesUseCase()) {
        self.getAllHeroesUseCase = getAllHeroesUseCase
    }

    // Ejecuta la solicitud para obtener un héroe específico por su id
    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void) {
        getAllHeroesUseCase.execute { result in
            switch result {
            case .success(let heroes):
                // Filtra los héroes por el id que coincide
                if let hero = heroes.first(where: { $0.identifier == heroId }) {
                    completion(.success(hero))
                } else {
                    completion(.failure(NSError(domain: "Hero not found", code: 404, userInfo: nil)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
