//
//  LoginViewModelTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

@testable import AppPatronesHernan
import XCTest

// MARK: - Success Mock for LoginUseCase
private final class SuccessLoginUseCaseMock: LoginUseCaseContract {
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        completion(.success(()))  // Simula éxito en el login
    }
}

// MARK: - Failure Mock for LoginUseCase
private final class FailedLoginUseCaseMock: LoginUseCaseContract {
    func execute(credentials: Credentials, completion: @escaping (Result<Void, LoginUseCaseError>) -> Void) {
        completion(.failure(LoginUseCaseError(reason: "Invalid credentials")))  // Simula fallo en el login
    }
}

// MARK: - LoginViewModel Tests
final class LoginViewModelTests: XCTestCase {
    
    // Test para verificar que el login se realiza correctamente en caso de éxito
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let loadingExpectation = expectation(description: "Loading")
        let sut = LoginViewModel(useCase: SuccessLoginUseCaseMock())
        
        sut.onStateChanged.bind { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .success:
                successExpectation.fulfill()
            case .error:
                XCTFail("Expected success but got error")
            }
        }
        
        sut.signIn("test@example.com", "password123")
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que el login falla con credenciales incorrectas
    func testFailureScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        let sut = LoginViewModel(useCase: FailedLoginUseCaseMock())
        
        sut.onStateChanged.bind { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .error(let reason):
                XCTAssertEqual(reason, "Invalid credentials")
                errorExpectation.fulfill()
            case .success:
                XCTFail("Expected error but got success")
            }
        }
        
        sut.signIn("test@example.com", "wrongpassword")
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que el login falla con credenciales vacías
    func testEmptyCredentialsScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        let sut = LoginViewModel(useCase: FailedLoginUseCaseMock())  // Usamos el mock de fallo para este caso también
        
        sut.onStateChanged.bind { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .error(let reason):
                XCTAssertEqual(reason, "Invalid credentials")  // El mensaje esperado al no proporcionar credenciales
                errorExpectation.fulfill()
            case .success:
                XCTFail("Expected error but got success")
            }
        }
        
        sut.signIn(nil, nil)  // Simulamos credenciales vacías
        waitForExpectations(timeout: 5)
    }
}
