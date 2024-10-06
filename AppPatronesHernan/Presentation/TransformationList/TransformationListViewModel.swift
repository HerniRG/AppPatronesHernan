//
//  TransformationListViewModel.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 6/10/24.
//

import Foundation

// MARK: - Transformation List State
enum TransformationListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

// MARK: - Transformation List ViewModel
final class TransformationListViewModel {
    let onStateChanged = Binding<TransformationListState>()
    private let id: String
    private(set) var transformations: [Transformation] = []
    private let useCase: GetTransformationUseCaseContract
    
    
    
    // Inicializa el ViewModel con el caso de uso para obtener las transformaciones
    init(id: String, useCase: GetTransformationUseCaseContract) {
        self.id = id
        self.useCase = useCase
    }
    
    // Carga la lista de transformaciones ordenadas y actualiza el estado
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute(heroId: id) { [weak self] result in
            do {
                self?.transformations = try result.get().sorted(by: {
                    $0.name.localizedStandardCompare($1.name) == .orderedAscending
                })
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
