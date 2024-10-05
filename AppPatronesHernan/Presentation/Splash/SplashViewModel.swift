//
//  SplashViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Splash State
enum SplashState {
    case loading
    case error
    case ready
}

// MARK: - Splash ViewModel
class SplashViewModel {
    var onStateChanged = Binding<SplashState>()
    
    // Simula la carga inicial de la aplicación
    func load() {
        onStateChanged.update(newValue: .loading)
        
        // Simulación de una carga de 3 segundos antes de pasar a "ready"
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.onStateChanged.update(newValue: .ready)
        }
    }
}
