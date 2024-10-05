//
//  HeroesListBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

// MARK: - Heroes List Builder
final class HeroesListBuilder {
    
    // Construye y retorna el controlador de la lista de héroes dentro de un UINavigationController
    func build() -> UIViewController {
        let useCase = GetAllHeroesUseCase()
        let viewModel = HeroesListViewModel(useCase: useCase)
        let viewController = HeroesListViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        return navigationController
    }
}
