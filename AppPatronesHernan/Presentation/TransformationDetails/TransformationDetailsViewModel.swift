//
//  TransformationDetailsViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 7/10/24.
//

import Foundation

enum TransformationDetailsState {
    case loading
    case success
    case error
}

// MARK: - Transformation Details ViewModel
final class TransformationDetailsViewModel {
    let onStateChanged = Binding<TransformationDetailsState>()
    private let heroId: String
    private let transformationId: String
    private let getSingleTransformationUseCase: GetSingleTransformationUseCaseContract
    private(set) var transformation: Transformation?
    
    // Inicializa el ViewModel con el caso de uso y sus propiedades
    init(heroId: String, transformationId: String, getSingleTransformationUseCase: GetSingleTransformationUseCaseContract, transformation: Transformation? = nil) {
        self.heroId = heroId
        self.transformationId = transformationId
        self.getSingleTransformationUseCase = getSingleTransformationUseCase
        self.transformation = transformation
    }
    
    func loadTransformationDetails() {
        onStateChanged.update(newValue: .loading)
        
        // Obtenemos la transformación por su id
        getSingleTransformationUseCase.execute(heroId: heroId, transformationId: transformationId) { [weak self] result in
            switch result {
            case .success(let transformation):
                self?.transformation = transformation
                self?.onStateChanged.update(newValue: .success)
            case .failure:
                self?.onStateChanged.update(newValue: .error)
            }
        }
    }
}
