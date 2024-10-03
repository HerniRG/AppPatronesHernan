//
//  HeroeDetailsBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import UIKit

final class HeroeDetailsBuilder {
    
    func build(with hero: Hero) -> UIViewController {
        let useCase = GetTransformationUseCase()
        let viewModel = HeroDetailsViewModel(hero: hero, useCase: useCase)
        let viewController = HeroDetailsViewController(viewModel: viewModel)
        
        return viewController
    }
}

