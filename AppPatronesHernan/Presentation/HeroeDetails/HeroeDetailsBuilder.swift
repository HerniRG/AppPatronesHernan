//
//  HeroeDetailsBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import UIKit

// MARK: - Heroe Details Builder
final class HeroeDetailsBuilder {
    private let id: String
    
    // Inicializa el builder con el ID del héroe
    init(id: String) {
        self.id = id
    }
    
    // Construye el HeroDetailsViewController con los casos de uso necesarios
    func build() -> UIViewController {
        let getHeroUseCase = GetSingleHeroUseCase()
        let getTransformationUseCase = GetTransformationUseCase()
        let viewModel = HeroDetailsViewModel(id: id, getHeroUseCase: getHeroUseCase, getTransformationUseCase: getTransformationUseCase)
        let viewController = HeroDetailsViewController(viewModel: viewModel)
        
        // Retornar el ViewController construido
        return viewController
    }
}
