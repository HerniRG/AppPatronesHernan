//
//  LoginViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Login State
enum LoginState {
    case success
    case error(reason: String)
    case loading
}

// MARK: - Login ViewModel
final class LoginViewModel {
    let onStateChanged = Binding<LoginState>()
    private let useCase: LoginUseCaseContract
    
    // Inicializa el ViewModel con el caso de uso para el login
    init(useCase: LoginUseCaseContract) {
        self.useCase = useCase
    }
    
    // Realiza el proceso de inicio de sesión
    func signIn(_ username: String?, _ password: String?) {
        onStateChanged.update(newValue: .loading)
        let credentials = Credentials(username: username ?? "", password: password ?? "")
        
        // Ejecuta el caso de uso con las credenciales
        useCase.execute(credentials: credentials) { [weak self] result in
            do {
                try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch let error as LoginUseCaseError {
                self?.onStateChanged.update(newValue: .error(reason: error.reason))
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: "Something has happened"))
            }
        }
    }
}
