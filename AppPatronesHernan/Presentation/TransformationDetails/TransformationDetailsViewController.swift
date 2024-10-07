//
//  TransformationDetailsViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 7/10/24.
//

import UIKit

class TransformationDetailsViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var transformationImage: AsyncImageView!
    @IBOutlet weak var transformationDescription: UILabel!
    
    private let viewModel: TransformationDetailsViewModel
    
    // Inicialización con ViewModel
    init(viewModel: TransformationDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationDetailsViewController", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(title: nil, backgroundColor: .systemIndigo)
        configureTranformationDetails()
        viewModel.loadTransformationDetails()
        bind()
    }
    
    // MARK: - Binding ViewModel
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .success:
                self?.renderSuccess()
            case .loading:
                self?.renderLoading()
            case .error:
                print("Error loading transformation details")
            }
        }
    }
    
    // MARK: - Configure Transformation Details View
    private func configureTranformationDetails() {
        transformationDescription.isHidden = true
        transformationImage.isHidden = true
        spinner.startAnimating()
        
        transformationImage.layer.cornerRadius = 10
        transformationImage.layer.masksToBounds = true
        transformationImage.layer.borderWidth = 1.0
        transformationImage.layer.borderColor = UIColor.gray.cgColor
        
        // Inicialmente ocultamos la imagen y la descripción con opacidad baja
        transformationImage.alpha = 0
        transformationDescription.alpha = 0
        transformationImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Aparecerá más pequeña
    }

    // MARK: - Update Transformation Details
    private func updateTransformationDetails() {
        guard let transformation = viewModel.transformation else { return }
        configureNavigationBar(title: transformation.name, backgroundColor: .systemIndigo)
        transformationImage.setImage(transformation.photo)
        transformationDescription.text = transformation.description
    }

    // MARK: - Render States
    private func renderSuccess() {
        spinner.stopAnimating()
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            // Mostramos la imagen y descripción con un efecto de fade y rebote
            self.updateTransformationDetails()
            self.transformationImage.isHidden = false
            self.transformationDescription.isHidden = false
            
            self.transformationImage.alpha = 1.0
            self.transformationDescription.alpha = 1.0
            self.transformationImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // Efecto de "rebote"
        }, completion: nil)
    }

    private func renderLoading() {
        UIView.animate(withDuration: 0.3) {
            self.transformationDescription.isHidden = true
            self.transformationImage.isHidden = true
            self.transformationImage.alpha = 0 // Ocultamos con fade
            self.transformationDescription.alpha = 0
            self.transformationImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8) // Reducimos su tamaño al ocultarla
        }
        spinner.startAnimating()
    }

}

