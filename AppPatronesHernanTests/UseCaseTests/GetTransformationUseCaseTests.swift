//
//  GetTransformationUseCaseTests.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 4/10/24.
//

@testable import AppPatronesHernan
import XCTest

final class APISessionGetTransformationsMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, any Error>)
    
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, any Error>) {
        self.mockResponse = mockResponse
    }
    
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(mockResponse(apiRequest))
    }
}

final class GetTransformationUseCaseTests: XCTestCase {
    
    func testSuccessReturnsTransformations() {
        let sut = GetTransformationUseCase()
        
        let expectation = self.expectation(description: "TestSuccess")
        let transformation = Transformation(id: "2", name: "Super Namekian", description: "Piccolo's fusion form", photo: "piccolo_super_namekian.jpg")
        
        let transformationsData: Data
        do {
            transformationsData = try JSONEncoder().encode([transformation])
        } catch {
            XCTFail("Error al codificar la transformación: \(error)")
            return
        }
        
        APISession.shared = APISessionGetTransformationsMock { _ in .success(transformationsData) }
        sut.execute(heroId: "2") { result in
            switch result {
            case .success(let transformations):
                XCTAssertEqual(transformations.count, 1)
                XCTAssertEqual(transformations.first?.name, "Super Namekian")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testFailureReturnsError() {
        let sut = GetTransformationUseCase()
        
        let expectation = self.expectation(description: "TestFailure")
        
        APISession.shared = APISessionGetTransformationsMock { _ in .failure(APIErrorResponse.network("transformations-fail")) }
        sut.execute(heroId: "2") { result in
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
