//
//  UIViewController+NavigationBar.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import UIKit

// MARK: - Navigation Bar Configuration
extension UIViewController {
    
    /// Configura la barra de navegación con un título y color de fondo.
    func configureNavigationBar(title: String?, backgroundColor: UIColor) {
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = UIColor.black
        
        // Configura la apariencia para diferentes estados de la barra de navegación
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
    }
}
