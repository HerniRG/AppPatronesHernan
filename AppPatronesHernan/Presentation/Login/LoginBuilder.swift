//
//  LoginBuilder.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

final class LoginBuilder {
    func build() -> UIViewController {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        return viewController
    }
}

