//
//  HeroesListViewModelTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

@testable import AppPatronesHernan
import XCTest

private final class SuccessGetHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[AppPatronesHernan.Hero], any Error>) -> Void) {
        completion(.success([Hero(identifier: "1234",
                                  name: "potato",
                                  description: "",
                                  photo: "",
                                  favorite: false)]))
    }
}

private final class FailedGetHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[AppPatronesHernan.Hero], any Error>) -> Void) {
        completion(.failure(APIErrorResponse.unknown("")))
    }
}


final class HeroesListViewModelTests: XCTestCase {
    
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
