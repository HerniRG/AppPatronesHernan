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
    case loading
    case error
}

final class HeroDetailsViewModel {
    let onStateChanged = Binding<HeroDetailsState>()
    private let id: String
    private let getHeroUseCase: GetSingleHeroUseCaseContract
    private let getTransformationUseCase: GetTransformationUseCaseContract
    private(set) var hero: Hero?
    private(set) var transformations: [Transformation] = []
    
    init(id: String, getHeroUseCase: GetSingleHeroUseCaseContract, getTransformationUseCase: GetTransformationUseCaseContract) {
        self.id = id
        self.getHeroUseCase = getHeroUseCase
        self.getTransformationUseCase = getTransformationUseCase
    }
    
    func loadHeroDetails() {
        onStateChanged.update(newValue: .loading)
        
        // Obtenemos el héroe por id
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
