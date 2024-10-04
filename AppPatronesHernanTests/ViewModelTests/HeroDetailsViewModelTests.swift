//
//  HeroDetailsViewModelTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

@testable import AppPatronesHernan
import XCTest

private final class SuccessGetHeroUseCaseMock: GetSingleHeroUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void) {
        let hero = Hero(identifier: "1", name: "Goku", description: "Saiyan warrior", photo: "goku.jpg", favorite: false)
        completion(.success(hero))
    }
}

private final class FailedGetHeroUseCaseMock: GetSingleHeroUseCaseContract {
    func execute(heroId: String, completion: @escaping (Result<Hero, Error>) -> Void) {
        completion(.failure(APIErrorResponse.network("hero-fail")))
    }
}

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
        let expectation = self.expectation(description: "Success")
        let sut = HeroDetailsViewModel(id: "1", getHeroUseCase: SuccessGetHeroUseCaseMock(), getTransformationUseCase: SuccessGetTransformationUseCaseMock())
        
        sut.onStateChanged.bind { state in
            if state == .success {
                expectation.fulfill()
            }
        }
        
        sut.loadHeroDetails()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 1)
        XCTAssertEqual(sut.hero?.name, "Goku")
    }
    
    func testNoTransformationsScenario() {
        let expectation = self.expectation(description: "NoButton")
        let transformationMock = SuccessGetTransformationUseCaseMock()
        transformationMock.returnEmptyTransformations = true
        let sut = HeroDetailsViewModel(id: "1", getHeroUseCase: SuccessGetHeroUseCaseMock(), getTransformationUseCase: transformationMock)
        
        sut.onStateChanged.bind { state in
            if state == .noButton {
                expectation.fulfill()
            }
        }
        
        sut.loadHeroDetails()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 0)
    }
    
    func testFailureScenario() {
        let expectation = self.expectation(description: "Error")
        let sut = HeroDetailsViewModel(id: "1", getHeroUseCase: FailedGetHeroUseCaseMock(), getTransformationUseCase: FailedGetTransformationUseCaseMock())
        
        sut.onStateChanged.bind { state in
            if state == .error {
                expectation.fulfill()
            }
        }
        
        sut.loadHeroDetails()
        waitForExpectations(timeout: 5)
        XCTAssertEqual(sut.transformations.count, 0)
    }
}
