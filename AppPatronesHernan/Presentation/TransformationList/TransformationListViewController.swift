//
//  TransformationListViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 6/10/24.
//

import UIKit

// MARK: - Transformation List View Controller
final class TransformationListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private let viewModel: TransformationListViewModel
    
    // MARK: - Initialization
    init(viewModel: TransformationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransformationListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TransformationTableViewCell.nib, forCellReuseIdentifier: TransformationTableViewCell.reuseIdentifier)
        
        configureNavigationBar(title: "Transformaciones", backgroundColor: .systemIndigo)
        bind()
        viewModel.load()
    }
    
    @IBAction func onRetryTapped(_ sender: Any) {
        renderLoading()
        viewModel.load()
    }
    
    
    // MARK: - Bind ViewModel to UI
    private func bind() {
        viewModel.onStateChanged.bind { [weak self] state in
            switch state {
            case .loading:
                self?.renderLoading()
            case .success:
                self?.renderSuccess()
            case .error(let error):
                self?.renderError(error)
            }
        }
    }
    
    // MARK: - UI State Rendering
    private func renderError(_ reason: String) {
        spinner.stopAnimating()
        errorContainer.isHidden = false
        tableView.isHidden = true
        errorLabel.text = reason
    }
    
    private func renderLoading() {
        spinner.startAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = true
    }
    
    private func renderSuccess() {
        spinner.stopAnimating()
        errorContainer.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transformations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransformationTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? TransformationTableViewCell {
            let transformation = viewModel.transformations[indexPath.row]
            cell.setAvatar(transformation.photo)
            cell.setHeroName(transformation.name)
        }   
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(viewModel.transformations[indexPath.row])
    }
}
