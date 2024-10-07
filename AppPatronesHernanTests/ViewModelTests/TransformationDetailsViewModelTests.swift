//
//  TransformationDetailsViewModelTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 7/10/24.
//

@testable import AppPatronesHernan
import XCTest

// MARK: - Success Mock for GetSingleTransformationUseCase
private final class SuccessGetSingleTransformationUseCaseMock: GetSingleTransformationUseCaseContract {
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation, Error>) -> Void) {
        let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Goku's transformation", photo: "ssj.jpg", hero: HeroId(id: "hero1"))
        completion(.success(transformation))
    }
}

// MARK: - Failure Mock for GetSingleTransformationUseCase
private final class FailedGetSingleTransformationUseCaseMock: GetSingleTransformationUseCaseContract {
    func execute(heroId: String, transformationId: String, completion: @escaping (Result<Transformation, Error>) -> Void) {
        completion(.failure(APIErrorResponse.unknown("Error loading transformation")))
    }
}

// MARK: - TransformationDetailsViewModel Tests
final class TransformationDetailsViewModelTests: XCTestCase {
    
    // Test para verificar que los detalles de la transformación se cargan correctamente en caso de éxito
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = SuccessGetSingleTransformationUseCaseMock()
        let sut = TransformationDetailsViewModel(heroId: "hero1", transformationId: "1", getSingleTransformationUseCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if state == .success {
                successExpectation.fulfill()
            }
        }
        
        sut.loadTransformationDetails()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformation?.id, "1")
        XCTAssertEqual(sut.transformation?.name, "Super Saiyan")
    }
    
    // Test para verificar que se maneja correctamente el error en la carga de detalles de la transformación
    func testFailureScenario() {
        let errorExpectation = expectation(description: "Error")
        let loadingExpectation = expectation(description: "Loading")
        let useCaseMock = FailedGetSingleTransformationUseCaseMock()
        let sut = TransformationDetailsViewModel(heroId: "hero1", transformationId: "1", getSingleTransformationUseCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if state == .error {
                errorExpectation.fulfill()
            }
        }
        
        sut.loadTransformationDetails()
        waitForExpectations(timeout: 5)
        XCTAssertNil(sut.transformation)
    }
}
