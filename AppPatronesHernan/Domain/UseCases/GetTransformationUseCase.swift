//
//  GetTransformationUseCase.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import Foundation

protocol GetTransformationUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void)
}

final class GetTransformationUseCase: GetTransformationUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        GetTransformationsAPIRequest(heroId: heroId)
            .perform { result in
                do {
                    let transformations = try result.get()
                    print("Transformations received: \(transformations)")  
                    completion(.success(transformations))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}
