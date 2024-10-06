//
//  TransformationListBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 6/10/24.
//

import UIKit

// MARK: - Transformation List Builder
final class TransformationListBuilder {
    private let id: String
    
    // Inicializa el builder con el ID del héroe
    init(id: String) {
        self.id = id
    }
    
    // Construye y retorna el controlador de la lista de transformaciones dentro de un viewController
    func build() -> UIViewController {
        let useCase = GetTransformationUseCase()
        let viewModel = TransformationListViewModel(id: id, useCase: useCase)
        let viewController = TransformationListViewController(viewModel: viewModel)
        
        viewController.modalPresentationStyle = .fullScreen
        
        return viewController
    }
}
