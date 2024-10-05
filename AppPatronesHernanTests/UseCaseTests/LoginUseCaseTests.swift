//
//  LoginUseCaseTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

@testable import AppPatronesHernan
import XCTest

// MARK: - API Session Mock for Login
final class APISessionLoginMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    // Inicializa el mock con una respuesta simulada
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    // Simula la petición del API, devolviendo la respuesta simulada
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest))
    }
}

// MARK: - Dummy Session Data Source
final class DummySessionDataSource: SessionDataSourceContract {
    private(set) var session: Data?
    
    // Almacena la sesión simulada
    func storeSession(_ session: Data) {
        self.session = session
    }
    
    // No retorna ninguna sesión almacenada
    func getSession() -> Data? { nil }
}

// MARK: - Login Use Case Tests
final class LoginUseCaseTests: XCTestCase {
    
    // Test para verificar que el token se almacena correctamente en caso de éxito
    func testSuccessStoresToken() {
        let dataSource = DummySessionDataSource()
        let sut = LoginUseCase(dataSource: dataSource)
        
        let expectation = self.expectation(description: "TestSuccess")
        let data = Data("hello-world".utf8)
        
        APISession.shared = APISessionLoginMock { _ in .success(data) }
        sut.execute(credentials: Credentials(username: "a@b.es", password: "122345")) { result in
            guard case .success = result else {
                return
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        XCTAssertEqual(dataSource.session, data)
    }
    
    // Test para verificar que el token no se almacena en caso de fallo
    func testFailureDoesNotStoreToken() {
        let dataSource = DummySessionDataSource()
        let sut = LoginUseCase(dataSource: dataSource)
        
        let expectation = self.expectation(description: "TestFailure")
        
        APISession.shared = APISessionLoginMock { _ in .failure(APIErrorResponse.network("login-fail")) }
        
        sut.execute(credentials: Credentials(username: "a@b.es", password: "123456")) { result in
            guard case .failure = result else {
                return
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5)
        XCTAssertNil(dataSource.session)
    }
}
