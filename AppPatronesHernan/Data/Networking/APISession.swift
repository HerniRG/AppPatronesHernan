//
//  APISession.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - APISession Contract
protocol APISessionContract {
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

// MARK: - APISession Implementation
struct APISession: APISessionContract {
    static var shared: APISessionContract = APISession()
    
    private let session = URLSession(configuration: .default)
    private let requestInterceptors: [APIRequestInterceptor]
    
    // Inicializa la sesión con interceptores (por defecto incluye autenticación)
    init(requestInterceptors: [APIRequestInterceptor] = [AuthenticationRequestInterceptor()]) {
        self.requestInterceptors = requestInterceptors
    }
    
    // Realiza la solicitud a través del protocolo APIRequest
    func request<Request: APIRequest>(apiRequest: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            var request = try apiRequest.getRequest()
            
            // Aplica los interceptores al request
            requestInterceptors.forEach { $0.intercept(request: &request) }
            
            // Ejecuta la solicitud HTTP
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
