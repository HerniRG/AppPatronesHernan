//
//  LoginUseCase.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Login Use Case Contract
protocol LoginUseCaseContract {
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void)
}

// MARK: - Login Use Case Implementation
final class LoginUseCase: LoginUseCaseContract {
    private let dataSource: SessionDataSourceContract
    
    // Inicializa el caso de uso con un origen de datos para manejar la sesión
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    // Ejecuta la solicitud de login con validación de credenciales
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        guard validateUsername(credentials.username) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid username")))
        }
        guard validatePassword(credentials.password) else {
            return completion(.failure(LoginUseCaseError(reason: "Invalid password")))
        }
        
        // Realiza la solicitud a la API de login
        LoginAPIRequest(credentials: credentials)
            .perform { [weak self] result in
                switch result {
                case .success(let token):
                    self?.dataSource.storeSession(token)  // Almacena el token en la sesión
                    completion(.success(()))
                case .failure:
                    completion(.failure(LoginUseCaseError(reason: "Network failed")))
                }
            }
    }
    
    // Valida el nombre de usuario
    private func validateUsername(_ username: String) -> Bool {
        username.contains("@") && !username.isEmpty
    }
    
    // Valida la contraseña
    private func validatePassword(_ password: String) -> Bool {
        password.count >= 4
    }
}

// MARK: - Login Use Case Error
struct LoginUseCaseError: Error {
    let reason: String
}
