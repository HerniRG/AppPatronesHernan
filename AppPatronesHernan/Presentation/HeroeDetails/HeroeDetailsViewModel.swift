//
//  HeroeDetailsViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import Foundation

enum HeroDetailsState {
    case success
    case noButton
}

final class HeroDetailsViewModel {
    let onStateChanged = Binding<HeroDetailsState>()
    private let hero: Hero
    private let useCase: GetTransformationUseCaseContract
    private(set) var transformations: [Transformation] = []
    
    init(hero: Hero, useCase: GetTransformationUseCaseContract) {
        self.hero = hero
        self.useCase = useCase
    }
    
    var heroModel: Hero {
        return hero
    }
    
    func loadTransformation() {
        useCase.execute(heroId: hero.identifier) { [weak self] result in
            switch result {
            case .success(let transformations):
                self?.transformations = transformations
                
                // Verificar si hay alguna transformación para el héroe actual
                if !transformations.isEmpty {
                    print("Hero has transformations.") // Asegúrate de que esta línea se ejecute
                    self?.onStateChanged.update(newValue: .success)
                } else {
                    print("Hero does not have transformations.")
                    self?.onStateChanged.update(newValue: .noButton)
                }
            case .failure(let error):
                print("Error al cargar transformaciones: \(error.localizedDescription)")
                self?.onStateChanged.update(newValue: .noButton)
            }
        }
    }

}
