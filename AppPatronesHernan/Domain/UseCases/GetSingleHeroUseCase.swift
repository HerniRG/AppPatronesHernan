//
//  GetSingleHeroUseCase.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

import Foundation

protocol GetSingleHeroUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void)
}

final class GetSingleHeroUseCase: GetSingleHeroUseCaseContract {
    private let getAllHeroesUseCase: GetAllHeroesUseCaseContract

    init(getAllHeroesUseCase: GetAllHeroesUseCaseContract = GetAllHeroesUseCase()) {
        self.getAllHeroesUseCase = getAllHeroesUseCase
    }

    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void) {
        
        getAllHeroesUseCase.execute { result in
            switch result {
            case .success(let heroes):
                // Filtramos los héroes por el id que necesitamos
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
