//
//  HeroDetailsViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import UIKit

// MARK: - Hero Details View Controller
class HeroDetailsViewController: UIViewController {
    
    @IBOutlet private weak var heroImage: AsyncImageView!
    @IBOutlet private weak var heroDescription: UILabel!
    @IBOutlet private weak var transformationsButton: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    private let viewModel: HeroDetailsViewModel
    
    // Inicialización con ViewModel
    init(viewModel: HeroDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailsViewController", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(title: nil, backgroundColor: .systemIndigo)
        configureHeroDetails()
        viewModel.loadHeroDetails()
        bind()
    }
    
    // MARK: - Transformation Button Action
    @IBAction func onTransformationButtonTapped(_ sender: Any) {
        guard let hero = viewModel.hero else { return }
        let transformationViewController = TransformationListBuilder(id: hero.identifier).build()
        self.navigationController?.pushViewController(transformationViewController, animated: true)
    }
    
    // MARK: - Binding ViewModel
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .success:
                self?.renderSuccess()
            case .noButton:
                self?.renderNoButton()
            case .loading:
                self?.showLoadingState()
            case .error:
                print("Error loading hero details.")
            }
        }
    }
    
    // MARK: - Configure Hero Details View
    private func configureHeroDetails() {
        heroDescription.isHidden = true
        heroImage.isHidden = true
        transformationsButton.isHidden = true
        spinner.startAnimating()
        
        heroImage.layer.cornerRadius = 10
        heroImage.layer.masksToBounds = true
        heroImage.layer.borderWidth = 1.0
        heroImage.layer.borderColor = UIColor.gray.cgColor
    }
    
    // MARK: - Update Hero Details
    private func updateHeroDetails() {
        guard let hero = viewModel.hero else { return }
        configureNavigationBar(title: hero.name, backgroundColor: .systemIndigo)
        heroDescription.text = hero.description
        heroImage.setImage(hero.photo)
    }
    
    // MARK: - Render States
    private func renderSuccess() {
        spinner.stopAnimating()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.updateHeroDetails()
            
            // Animamos la opacidad y el escalado de las vistas
            self.heroDescription.isHidden = false
            self.heroImage.isHidden = false
            self.transformationsButton.isHidden = false
            
            self.heroDescription.alpha = 1.0
            self.heroImage.alpha = 1.0
            self.transformationsButton.alpha = 1.0
            self.heroImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        UIView.animate(withDuration: 0.3) {
            self.configureNavigationBar(title: self.viewModel.hero?.name, backgroundColor: .systemIndigo)
        }
    }
    
    private func renderNoButton() {
        spinner.stopAnimating()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.updateHeroDetails()
            
            // Solo ocultamos el botón de transformaciones
            self.transformationsButton.isHidden = true
            
            // Animamos la opacidad y el escalado de las vistas
            self.heroDescription.isHidden = false
            self.heroImage.isHidden = false
            
            self.heroDescription.alpha = 1.0
            self.heroImage.alpha = 1.0
            self.heroImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        UIView.animate(withDuration: 0.3) {
            self.configureNavigationBar(title: self.viewModel.hero?.name, backgroundColor: .systemIndigo)
        }
    }
    
    private func showLoadingState() {
        UIView.animate(withDuration: 0.3) {
            // Ocultamos las vistas con opacidad
            self.heroDescription.isHidden = true
            self.heroImage.isHidden = true
            self.transformationsButton.isHidden = true
            
            self.heroDescription.alpha = 0.0
            self.heroImage.alpha = 0.0
            self.transformationsButton.alpha = 0.0
            
            // Reducimos el tamaño de la imagen mientras está oculta
            self.heroImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        spinner.startAnimating()
    }
    
}
