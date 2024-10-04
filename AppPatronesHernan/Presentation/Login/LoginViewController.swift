//
//  LoginViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        viewModel.signIn(userNameField.text, passwordField.text)
    }
    
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .success:
                self?.renderSuccess()
                self?.present(HeroesListBuilder().build(), animated: true)
            case .error(let reason):
                self?.renderError(reason)
            case .loading:
                self?.renderLoading()
            }
        }
    }
    
    // MARK: - State rendering functions
    private func renderSuccess() {
        UIView.animate(withDuration: 0.6) {
            self.signInButton.isHidden = true
            self.spinner.stopAnimating()
            self.errorLabel.isHidden = true
            self.containerView.isHidden = true
        }
    }
    
    private func renderError(_ reason: String) {
        UIView.animate(withDuration: 0.6) {
            self.signInButton.isHidden = false
            self.spinner.stopAnimating()
            self.errorLabel.isHidden = false
            self.errorLabel.text = reason
            self.containerView.isHidden = false
        }
    }
    
    private func renderLoading() {
        UIView.animate(withDuration: 0.6) {
            self.signInButton.isHidden = true
            self.spinner.startAnimating()
            self.errorLabel.isHidden = true
            self.containerView.isHidden = true
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Redondear esquinas del containerView
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        // Opcional: Si quieres agregar un borde al containerView
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }
}

#Preview {
    LoginBuilder().build()
}
