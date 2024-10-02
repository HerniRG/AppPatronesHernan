//
//  APISession.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

protocol APISessionContract {
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

struct APISession: APISessionContract {
    static var shared: APISessionContract = APISession()
    
    private let session = URLSession(configuration: .default)
    private let requestInterceptors: [APIRequestInterceptor]
    
    init(requestInterceptors: [APIRequestInterceptor] = [AuthenticationRequestInterceptor()]) {
        self.requestInterceptors = requestInterceptors
    }
    
    func request<Request: APIRequest >(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            var request = try apiRequest.getRequest()
            
            requestInterceptors.forEach { $0.intercept(request: &request) }
            
            session.dataTask(with: request) { data, response, error in
                if let error {
                    return completion(.failure(error))
                }
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    return completion(.failure(APIErrorResponse.network(apiRequest.path)))
                }
                return completion(.success(data ?? Data()))
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
}
