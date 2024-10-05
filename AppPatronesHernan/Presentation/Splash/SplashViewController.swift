//
//  SplashViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

// MARK: - Splash View Controller
final class SplashViewController: UIViewController {
    
    private let viewModel: SplashViewModel
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Initialization
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()  // Vincula el estado del ViewModel con la UI
        viewModel.load()  // Carga los datos iniciales
    }
    
    // MARK: - Bind ViewModel to UI
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.setAnimation(true)
            case .ready:
                self?.setAnimation(false)
                self?.present(LoginBuilder().build(), animated: true)
            case .error:
                break  // Manejo de error si es necesario
            }
        }
    }
    
    // MARK: - Control Spinner Animation
    private func setAnimation(_ animating: Bool) {
        switch spinner.isAnimating {
        case true where !animating:
            spinner.stopAnimating()
        case false where animating:
            spinner.startAnimating()
        default:
            break
        }
    }
}

#Preview {
    SplashBuilder().build()
}
