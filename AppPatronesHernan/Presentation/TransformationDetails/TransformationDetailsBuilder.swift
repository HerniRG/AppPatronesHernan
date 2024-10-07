//
//  TransformationDetailsBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 7/10/24.
//

import UIKit

// MARK: - Transformation Details Builder
final class TransformationDetailsBuilder {
    private let heroId: String
    private let transformationId: String
    
    // Inicialización del builder con los IDs necesarios
    init(heroId: String, transformationId: String) {
        self.heroId = heroId
        self.transformationId = transformationId
    }
    
    // Método para construir y retornar el ViewController de detalles de la transformación
    func build() -> UIViewController {
        let getSingleTransformationUseCase = GetSingleTransformationUseCase()  // Usa el caso de uso que creaste
        let viewModel = TransformationDetailsViewModel(heroId: heroId, transformationId: transformationId, getSingleTransformationUseCase: getSingleTransformationUseCase)
        let viewController = TransformationDetailsViewController(viewModel: viewModel)
        
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
