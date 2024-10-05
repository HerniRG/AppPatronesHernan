//
//  GetSingleHeroUseCaseTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

@testable import AppPatronesHernan
import XCTest

// MARK: - Success Mock for GetAllHeroesUseCase
private final class SuccessGetAllHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[Hero], Error>) -> Void) {
        let heroes = [
            Hero(identifier: "1", name: "Goku", description: "Saiyan warrior", photo: "goku.jpg", favorite: false),
            Hero(identifier: "2", name: "Vegeta", description: "Prince of Saiyans", photo: "vegeta.jpg", favorite: true)
        ]
        completion(.success(heroes))
    }
}

// MARK: - Failure Mock for GetAllHeroesUseCase
private final class FailedGetAllHeroesUseCaseMock: GetAllHeroesUseCaseContract {
    func execute(completion: @escaping (Result<[Hero], Error>) -> Void) {
        completion(.failure(APIErrorResponse.network("heroes-fail")))
    }
}

// MARK: - GetSingleHeroUseCase Tests
final class GetSingleHeroUseCaseTests: XCTestCase {
    
    // Test para verificar que se devuelve el héroe correcto en caso de éxito
    func testSuccessReturnsSingleHero() {
        let sut = GetSingleHeroUseCase(getAllHeroesUseCase: SuccessGetAllHeroesUseCaseMock())
        
        let expectation = self.expectation(description: "TestSuccess")
        
        sut.execute(heroId: "1") { result in
            switch result {
            case .success(let hero):
                XCTAssertEqual(hero.identifier, "1")
                XCTAssertEqual(hero.name, "Goku")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que se devuelve un error en caso de fallo
    func testFailureReturnsError() {
        let sut = GetSingleHeroUseCase(getAllHeroesUseCase: FailedGetAllHeroesUseCaseMock())
        
        let expectation = self.expectation(description: "TestFailure")
        
        sut.execute(heroId: "1") { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    // Test para verificar que se devuelve un error cuando no se encuentra el héroe
    func testHeroNotFoundReturnsError() {
        let sut = GetSingleHeroUseCase(getAllHeroesUseCase: SuccessGetAllHeroesUseCaseMock())
        
        let expectation = self.expectation(description: "TestHeroNotFound")
        
        sut.execute(heroId: "999") { result in  // Usamos un ID que no existe
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual((error as NSError).domain, "Hero not found")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
    }
}
