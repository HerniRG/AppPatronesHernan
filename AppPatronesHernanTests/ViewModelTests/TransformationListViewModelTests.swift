//
//  TransformationListViewModelTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 6/10/24.
//

@testable import AppPatronesHernan
import XCTest

// MARK: - Success Mock for GetTransformationUseCase
private final class SuccessGetTransformationUseCaseMock: GetTransformationUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        let transformations = [
            Transformation(id: "1", name: "Super Saiyan", description: "Goku's transformation", photo: "ssj.jpg"),
            Transformation(id: "2", name: "Ultra Instinct", description: "Goku's ultimate form", photo: "ui.jpg")
        ]
        completion(.success(transformations))
    }
}

// MARK: - Failure Mock for GetTransformationUseCase
private final class FailedGetTransformationUseCaseMock: GetTransformationUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        completion(.failure(APIErrorResponse.unknown("Error loading transformations")))
    }
}

// MARK: - TransformationListViewModel Tests
final class TransformationListViewModelTests: XCTestCase {
    
    // Test para verificar que la lista de transformaciones se carga correctamente en caso de éxito
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = SuccessGetTransformationUseCaseMock()
        let sut = TransformationListViewModel(id: "1", useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if state == .success {
                successExpectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 2)
        XCTAssertEqual(sut.transformations.first?.name, "Super Saiyan")
    }
    
    // Test para verificar que se maneja correctamente el error en la carga de transformaciones
    func testFailureScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = FailedGetTransformationUseCaseMock()
        let sut = TransformationListViewModel(id: "1", useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if case .error(let reason) = state {
                errorExpectation.fulfill()
            }
        }
        
        sut.load()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 0)
    }
}
