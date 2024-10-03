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
        title = viewModel.heroModel.name
        heroDescription.text = viewModel.heroModel.description
        heroImage.setImage(viewModel.heroModel.photo)
        viewModel.loadTransformation()
        bind()
    }
    
    @IBAction func onTransformationButtonTapped(_ sender: Any) {
        print("Transformations for hero \(viewModel.heroModel.name):")
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
            }
        }
    }
    
    // MARK: - State rendering functions
    private func renderSuccess() {
        transformationsButton.isHidden = false
    }
    
    private func renderNoButton() {
        transformationsButton.isHidden = true
    }
    
}
