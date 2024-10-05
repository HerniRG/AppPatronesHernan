//
//  LoginBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

// MARK: - Login Builder
final class LoginBuilder {
    
    // Construye y retorna el controlador de la vista de login
    func build() -> UIViewController {
        let loginUseCase = LoginUseCase()
        let viewModel = LoginViewModel(useCase: loginUseCase)
        let viewController = LoginViewController(viewModel: viewModel)
        
        // Configuración de la transición y presentación del controlador
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        
        return viewController
    }
}
