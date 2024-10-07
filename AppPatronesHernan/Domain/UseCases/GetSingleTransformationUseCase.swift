//  GetSingleTransformationUseCase.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 7/10/24.
//

import Foundation

// MARK: - Get Single Transformation Use Case Contract
protocol GetSingleTransformationUseCaseContract {
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation, Error>) -> Void)
}

// MARK: - Get Single Transformation Use Case Implementation
final class GetSingleTransformationUseCase: GetSingleTransformationUseCaseContract {
    private let getAllTransformationsUseCase: GetTransformationUseCaseContract
    
    // Inicializa con el caso de uso para obtener todas las transformaciones del heroId
    init(getAllTransformationsUseCase: GetTransformationUseCaseContract = GetTransformationUseCase()) {
        self.getAllTransformationsUseCase = getAllTransformationsUseCase
    }
    
    // Ejecuta la solicitud para obtener una transformación con su id específico
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation, any Error>) -> Void) {
        getAllTransformationsUseCase.execute(heroId: heroId) { result in
            switch result {
            case .success(let transformations):
                // Filtra las transformaciones por el id que coincide
                if let transformation = transformations.first(where: { $0.id == transformationId }) {
                    completion(.success(transformation))
                } else {
                    completion(.failure(TransformationError.notFound))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Transformation Error
enum TransformationError: Error {
    case notFound
}
