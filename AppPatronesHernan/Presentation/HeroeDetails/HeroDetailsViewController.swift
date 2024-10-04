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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
        configureNavigationBar(title: nil, backgroundColor: .systemIndigo)
        configureHeroDetails()
        viewModel.loadHeroDetails()
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
    
    private func updateHeroDetails() {
        guard let hero = viewModel.hero else { return }
        configureNavigationBar(title: hero.name, backgroundColor: .systemIndigo)
        heroDescription.text = hero.description
        heroImage.setImage(hero.photo)
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.updateHeroDetails()
            self.heroDescription.isHidden = false
            self.heroImage.isHidden = false
            self.transformationsButton.isHidden = false
        })
        
        UIView.animate(withDuration: 0.3) {
            self.configureNavigationBar(title: self.viewModel.hero?.name, backgroundColor: .systemIndigo)
        }
    }
    
    private func renderNoButton() {
        spinner.stopAnimating()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.updateHeroDetails()
            self.transformationsButton.isHidden = true
            self.heroDescription.isHidden = false
            self.heroImage.isHidden = false
        })
        
        UIView.animate(withDuration: 0.3) {
            self.configureNavigationBar(title: self.viewModel.hero?.name, backgroundColor: .systemIndigo)
        }
    }
    
    private func showLoadingState() {
        UIView.animate(withDuration: 0.3) {
            self.heroDescription.isHidden = true
            self.heroImage.isHidden = true
            self.transformationsButton.isHidden = true
        }
        
        spinner.startAnimating()
    }
    
    
}
