//
//  LoginViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

enum LoginState {
    case success
    case error(reason: String)
    case loading
}

final class LoginViewModel {
    let onStateChanged = Binding<LoginState>()
    private let useCase: LoginUseCaseContract
    
    init(useCase: LoginUseCaseContract) {
        self.useCase = useCase
    }
    
    func signIn(_ username: String?, _ password: String?) {
        onStateChanged.update(newValue: .loading)
        let credentials = Credentials(username: username ?? "", password: password ?? "")
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
