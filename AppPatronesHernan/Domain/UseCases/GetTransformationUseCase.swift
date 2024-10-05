//
//  GetTransformationUseCase.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import Foundation

// MARK: - Get Transformation Use Case Contract
protocol GetTransformationUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void)
}

// MARK: - Get Transformation Use Case Implementation
final class GetTransformationUseCase: GetTransformationUseCaseContract {

    // Ejecuta la solicitud para obtener las transformaciones de un héroe por su id
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        GetTransformationsAPIRequest(heroId: heroId)
            .perform { result in
                do {
                    let transformations = try result.get()
                    completion(.success(transformations))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
