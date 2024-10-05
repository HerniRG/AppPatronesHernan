//
//  APIInterceptor.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - API Interceptor Base Protocol
protocol APIInterceptor { }

// MARK: - API Request Interceptor Protocol
protocol APIRequestInterceptor: APIInterceptor {
    func intercept(request: inout URLRequest)
}

// MARK: - Authentication Request Interceptor
final class AuthenticationRequestInterceptor: APIRequestInterceptor {
    private let dataSource: SessionDataSourceContract
    
    // Inicializa con una fuente de datos de sesión (por defecto utiliza SessionDataSource)
    init(dataSource: SessionDataSourceContract = SessionDataSource()) {
        self.dataSource = dataSource
    }
    
    // Añade el token de autenticación "Bearer" a la cabecera de la petición
    func intercept(request: inout URLRequest) {
        guard let session = dataSource.getSession() else {
            return
        }
        request.setValue("Bearer \(String(decoding: session, as: UTF8.self))", forHTTPHeaderField: "Authorization")
    }
}
