//
//  SplashViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let viewModel: SplashViewModel
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.setAnimation(true)
            case .ready:
                self?.setAnimation(false)
                self?.present(LoginBuilder().build(), animated: true)
            case .error:
                break
            }
        }
    }
    
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
