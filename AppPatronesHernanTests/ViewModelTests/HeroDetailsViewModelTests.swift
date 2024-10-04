//
//  HeroDetailsViewModelTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

@testable import AppPatronesHernan
import XCTest

private final class SuccessGetTransformationUseCaseMock: GetTransformationUseCaseContract {
    var returnEmptyTransformations = false

    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        if returnEmptyTransformations {
            completion(.success([]))
        } else {
            let transformation = Transformation(id: "1", name: "Super Saiyan", description: "Goku's first transformation", photo: "ssj.jpg")
            completion(.success([transformation]))
        }
    }
}

private final class FailedGetTransformationUseCaseMock: GetTransformationUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<[Transformation], Error>) -> Void) {
        completion(.failure(APIErrorResponse.network("transformations-fail")))
    }
}

final class HeroDetailsViewModelTests: XCTestCase {
    
    func testSuccessScenario() {
        let successExpectation = expectation(description: "Success")
        let sut = HeroDetailsViewModel(hero: Hero(identifier: "1", name: "Goku", description: "", photo: "", favorite: false), useCase: SuccessGetTransformationUseCaseMock())
        
        sut.onStateChanged.bind { state in
            if state == .success {
                successExpectation.fulfill()
            }
        }
        
        sut.loadTransformation()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 1)
    }
    
    func testNoTransformationsScenario() {
        let noButtonExpectation = expectation(description: "NoButton")
        let useCaseMock = SuccessGetTransformationUseCaseMock()
        useCaseMock.returnEmptyTransformations = true  // Simulamos que no hay transformaciones

        let sut = HeroDetailsViewModel(hero: Hero(identifier: "1", name: "Goku", description: "", photo: "", favorite: false), useCase: useCaseMock)
        
        sut.onStateChanged.bind { state in
            if state == .noButton {
                noButtonExpectation.fulfill()
            }
        }
        
        sut.loadTransformation()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 0)
    }
    
    func testFailureScenario() {
        let errorExpectation = expectation(description: "Error")
        let sut = HeroDetailsViewModel(hero: Hero(identifier: "1", name: "Goku", description: "", photo: "", favorite: false), useCase: FailedGetTransformationUseCaseMock())
        
        sut.onStateChanged.bind { state in
            if state == .noButton {
                errorExpectation.fulfill()
            }
        }
        
        sut.loadTransformation()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 0)
    }
}
