//
//  HeroesListViewModelTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

@testable import AppPatronesHernan
import XCTest

// MARK: - Success Mock for GetAllHeroesUseCase
private final class SuccessGetHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[AppPatronesHernan.Hero], any Error>) -> Void) {
        completion(.success([Hero(identifier: "1234",
                                  name: "potato",
                                  description: "",
                                  photo: "",
                                  favorite: false)]))
    }
}

// MARK: - Failure Mock for GetAllHeroesUseCase
private final class FailedGetHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[AppPatronesHernan.Hero], any Error>) -> Void) {
        completion(.failure(APIErrorResponse.unknown("")))
    }
}

// MARK: - HeroesListViewModel Tests
final class HeroesListViewModelTests: XCTestCase {
    
    // Test para verificar que la lista de héroes se carga correctamente en caso de éxito
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = SuccessGetHeroesUseCaseMock()
        let sut = HeroesListViewModel(useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if state == .success {
                successExpectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.heroes.count, 1)
    }
    
    // Test para verificar que se maneja correctamente el error en la carga de héroes
    func testFailScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = FailedGetHeroesUseCaseMock()
        let sut = HeroesListViewModel(useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if case .error = state {
                errorExpectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.heroes.count, 0)
    }
}
