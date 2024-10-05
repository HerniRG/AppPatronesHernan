//
//  SessionDataSource.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Session Data Source Contract
protocol SessionDataSourceContract {
    func storeSession(_ session: Data)
    func getSession() -> Data?
}

// MARK: - Session Data Source Implementation
final class SessionDataSource: SessionDataSourceContract {
    
    // Variable estática para almacenar el token de sesión
    private static var token: Data?
    
    // Almacena la sesión en la variable estática
    func storeSession(_ session: Data) {
        SessionDataSource.token = session
    }
    
    // Recupera la sesión almacenada
    func getSession() -> Data? {
        SessionDataSource.token
    }
}
