//
//  APIRequest.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, UPDATE, HEAD, PATCH, DELETE, OPTIONS
}

protocol APIRequest {
    var host: String { get }
    var method: HTTPMethod { get }
    var body: Encodable? { get }
    var path: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
    
    associatedtype Response: Decodable
    typealias APIRequestResponse = Result<Response, APIErrorResponse>
    typealias APIRequestCompletion = (APIRequestResponse) -> Void
}

extension APIRequest {
    var host: String { "dragonball.keepcoding.education" }
    var queryParameters: [String: String] { [:] }
    var headers: [String: String] { [:] }
    var body: Encodable? { nil }
    
    func getRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let finalURL = components.url else {
            throw APIErrorResponse.malformedURL(path)
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        if method != .GET, let body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        request.allHTTPHeaderFields = ["Accept": "application/json", "Content-Type": "application/json"].merging(headers) { $1 }
        request.timeoutInterval = 10
        return request
    }
}

// MARK: - Execution
extension APIRequest {
    func perform(session: APISessionContract = APISession.shared, completion: @escaping APIRequestCompletion) {
        session.request(apiRequest: self) { result in
            do {
                let data = try result.get()
                
                if Response.self == Void.self {
                    return completion(.success(() as! Response))
                } else if Response.self == Data.self {
                    return completion(.success(data as! Response))
                }
                
                return try completion(.success(JSONDecoder().decode(Response.self, from: data)))
            } catch let error as APIErrorResponse {
                completion(.failure(error))
            } catch {
                completion(.failure(APIErrorResponse.unknown(path)))
            }
        }
    }
}
