//
//  GetSingleTransformationUseCaseTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 7/10/24.
//

@testable import AppPatronesHernan
import XCTest

// MARK: - Success Mock for GetTransformationUseCase
private final class SuccessGetTransformationUseCaseMock: GetTransformationUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        let transformations = [
            Transformation(id: "1", name: "Super Saiyan", description: "Goku's transformation", photo: "ssj.jpg", hero: HeroId(id: "hero1")),
            Transformation(id: "2", name: "Ultra Instinct", description: "Goku's ultimate form", photo: "ui.jpg", hero: HeroId(id: "hero1"))
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

// MARK: - GetSingleTransformationUseCase Tests
final class GetSingleTransformationUseCaseTests: XCTestCase {
    
    // Test para verificar que se obtiene una transformación correctamente en caso de éxito
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let useCaseMock = SuccessGetTransformationUseCaseMock()
        let sut = GetSingleTransformationUseCase(getAllTransformationsUseCase: useCaseMock)
        
        sut.execute(heroId: "hero1", transformationId: "1") { result in
            switch result {
            case .success(let transformation):
                XCTAssertEqual(transformation.id, "1")
                XCTAssertEqual(transformation.name, "Super Saiyan")
                successExpectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que devuelve error si no encuentra la transformación
    func testTransformationNotFound() {
        let notFoundExpectation = expectation(description: "TransformationNotFound")
        let useCaseMock = SuccessGetTransformationUseCaseMock()
        let sut = GetSingleTransformationUseCase(getAllTransformationsUseCase: useCaseMock)
        
        sut.execute(heroId: "hero1", transformationId: "unknown_id") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? TransformationError, TransformationError.notFound)
                notFoundExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que se maneja correctamente el error de la API
    func testFailureScenario() {
        let errorExpectation = expectation(description: "Error")
        let useCaseMock = FailedGetTransformationUseCaseMock()
        let sut = GetSingleTransformationUseCase(getAllTransformationsUseCase: useCaseMock)
        
        sut.execute(heroId: "hero1", transformationId: "1") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                errorExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
    }
}
