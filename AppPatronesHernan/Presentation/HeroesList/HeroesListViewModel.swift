//
//  HeroesListViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import Foundation

// MARK: - Heroes List State
enum HeroesListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

// MARK: - Heroes List ViewModel
final class HeroesListViewModel {
    let onStateChanged = Binding<HeroesListState>()
    private(set) var heroes: [Hero] = []
    private let useCase: GetAllHeroesUseCaseContract
    
    // Inicializa el ViewModel con el caso de uso para obtener los héroes
    init(useCase: GetAllHeroesUseCaseContract) {
        self.useCase = useCase
    }
    
    // Carga la lista de héroes y actualiza el estado
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute { [weak self] result in
            do {
                self?.heroes = try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
