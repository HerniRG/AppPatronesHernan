//
//  HeroeDetailsViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import Foundation

// MARK: - Hero Details View State
enum HeroDetailsState {
    case success
    case noButton
    case loading
    case error
}

// MARK: - Hero Details ViewModel
final class HeroDetailsViewModel {
    let onStateChanged = Binding<HeroDetailsState>()
    private let id: String
    private let getHeroUseCase: GetSingleHeroUseCaseContract
    private let getTransformationUseCase: GetTransformationUseCaseContract
    private(set) var hero: Hero?
    private(set) var transformations: [Transformation] = []
    
    // Inicializa el ViewModel con los casos de uso necesarios
    init(id: String, getHeroUseCase: GetSingleHeroUseCaseContract, getTransformationUseCase: GetTransformationUseCaseContract) {
        self.id = id
        self.getHeroUseCase = getHeroUseCase
        self.getTransformationUseCase = getTransformationUseCase
    }
    
    // Carga los detalles del héroe
    func loadHeroDetails() {
        onStateChanged.update(newValue: .loading)
        
        // Obtenemos el héroe por su id
        getHeroUseCase.execute(heroId: id) { [weak self] result in
            switch result {
            case .success(let hero):
                self?.hero = hero
                self?.loadTransformations()
            case .failure:
                self?.onStateChanged.update(newValue: .error)
            }
        }
    }
    
    // Carga las transformaciones del héroe
    private func loadTransformations() {
        guard let hero = hero else { return }
        
        getTransformationUseCase.execute(heroId: hero.identifier) { [weak self] result in
            switch result {
            case .success(let transformations):
                self?.transformations = transformations
                if !transformations.isEmpty {
                    self?.onStateChanged.update(newValue: .success)
                } else {
                    self?.onStateChanged.update(newValue: .noButton)
                }
            case .failure:
                self?.onStateChanged.update(newValue: .error)
            }
        }
    }
}
