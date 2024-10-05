//
//  Binding.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Binding Class
final class Binding<State> {
    typealias Completion = (State) -> Void
    
    var completion: Completion?
    
    // Vincula un nuevo closure que será llamado cuando el estado cambie
    func bind(completion: @escaping Completion) {
        self.completion = completion
    }
    
    // Actualiza el estado y ejecuta el closure vinculado en el hilo principal
    func update(newValue: State) {
        DispatchQueue.main.async { [weak self] in
            self?.completion?(newValue)
        }
    }
}
