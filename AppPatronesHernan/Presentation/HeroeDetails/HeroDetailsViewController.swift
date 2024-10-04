//
//  HeroDetailsViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 3/10/24.
//

import UIKit

class HeroDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var heroImage: AsyncImageView!
    @IBOutlet weak var heroDescription: UILabel!
    @IBOutlet weak var transformationsButton: UIButton!
    
    private let viewModel: HeroDetailsViewModel
    
    init(viewModel: HeroDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroDetailsViewController", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(title: "Loading...", backgroundColor: .systemIndigo)
        configureHeroDetails()
        viewModel.loadHeroDetails()  // Ahora se carga el héroe y las transformaciones
        bind()
    }
    
    @IBAction func onTransformationButtonTapped(_ sender: Any) {
        guard let hero = viewModel.hero else { return }
        print("Transformations for hero \(hero.name):")
        viewModel.transformations.forEach { transformation in
            print("Transformation: \(transformation.name)")
        }
    }
    
    private func bind() {
            viewModel.onStateChanged.bind { [weak self] state in
                switch state {
                case .success:
                    print("Success state: showing button.")
                    self?.renderSuccess()
                case .noButton:
                    print("No button state: hiding button.")
                    self?.renderNoButton()
                case .loading:
                    print("Loading hero details...")
                case .error:
                    print("Error loading hero details.")
                }
            }
        }
    
    private func configureHeroDetails() {
            heroDescription.text = "Loading description..."
            heroImage.image = UIImage(named: "placeholder")
            transformationsButton.isHidden = true
        }
        
        private func updateHeroDetails() {
            guard let hero = viewModel.hero else { return }
            configureNavigationBar(title: hero.name, backgroundColor: .systemIndigo)
            heroDescription.text = hero.description
            heroImage.setImage(hero.photo)
        }
        
        // MARK: - State rendering functions
        private func renderSuccess() {
            updateHeroDetails()  // Una vez que tenemos el héroe, actualizamos los detalles
            transformationsButton.isHidden = false
        }
        
        private func renderNoButton() {
            updateHeroDetails()  // También actualizamos los detalles en este estado
            transformationsButton.isHidden = true
        }
    
}
