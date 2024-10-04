//
//  GetAllHeroesUseCaseTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

@testable import AppPatronesHernan
import XCTest

final class APISessionGetAllHeroesMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest))
    }
}

final class GetAllHeroesUseCaseTests: XCTestCase {
    
    func testSuccessReturnsHeroes() {
        let sut = GetAllHeroesUseCase()
        
        let expectation = self.expectation(description: "TestSuccess")
        let hero = Hero(identifier: "1", name: "Goku", description: "Saiyan", photo: "goku.jpg", favorite: false)
        
        let heroesData: Data
        do {
            heroesData = try JSONEncoder().encode([hero])
        } catch {
            XCTFail("Error al codificar el héroe: \(error)")
            return
        }
        
        APISession.shared = APISessionGetAllHeroesMock { _ in .success(heroesData) }
        sut.execute { result in
            switch result {
            case .success(let heroes):
                XCTAssertEqual(heroes.count, 1)
                XCTAssertEqual(heroes.first?.name, "Goku")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFailureReturnsError() {
        let sut = GetAllHeroesUseCase()
        
        let expectation = self.expectation(description: "TestFailure")
        
        APISession.shared = APISessionGetAllHeroesMock { _ in .failure(APIErrorResponse.network("heroes-fail")) }
        sut.execute { result in
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
}
