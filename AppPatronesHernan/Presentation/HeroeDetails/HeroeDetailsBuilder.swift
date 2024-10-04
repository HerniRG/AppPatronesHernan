//
//  HeroeDetailsBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import UIKit

final class HeroeDetailsBuilder {
    private let id: String
    
    init(id: String) {
        self.id = id
    }

    func build() -> UIViewController {
        let getHeroUseCase = GetSingleHeroUseCase()
        let getTransformationUseCase = GetTransformationUseCase()
        let viewModel = HeroDetailsViewModel(id: id, getHeroUseCase: getHeroUseCase, getTransformationUseCase: getTransformationUseCase)
        let viewController = HeroDetailsViewController(viewModel: viewModel)
        
        return viewController
    }
}
