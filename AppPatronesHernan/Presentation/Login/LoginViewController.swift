//
//  LoginViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

// MARK: - Login View Controller
final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var userNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var viewCenterYConstraint: NSLayoutConstraint!
    
    private let viewModel: LoginViewModel
    
    // MARK: - Initialization
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        setupKeyboardNotifications()  // Para manejar el teclado
    }
    
    // MARK: - Login Action
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        viewModel.signIn(userNameField.text, passwordField.text)
    }
    
    // MARK: - Bind ViewModel to UI
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
    
    // MARK: - State Rendering
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
        // Configuración de la vista contenedora
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        adjustViewForKeyboard(notification, isShowing: true)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        adjustViewForKeyboard(notification, isShowing: false)
    }
    
    private func adjustViewForKeyboard(_ notification: Notification, isShowing: Bool) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = isShowing ? keyboardFrame.height : 0
        viewCenterYConstraint.constant = isShowing ? -keyboardHeight / 2 : 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // Elimina los observadores del teclado
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview {
    LoginBuilder().build()
}
