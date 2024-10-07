//
//  HeroesListViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

// MARK: - Heroes List View Controller
final class HeroesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private let viewModel: HeroesListViewModel
    
    // MARK: - Initialization
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(HeroTableViewCell.nib, forCellReuseIdentifier: HeroTableViewCell.reuseIdentifier)
        
        configureNavigationBar(title: "Heroes", backgroundColor: .systemIndigo)
        bind()
        viewModel.load()
    }
    
    // MARK: - Retry Action
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
        UIView.animate(withDuration: 0.3, animations: {
            self.spinner.alpha = 0.0
        }) { _ in
            self.spinner.stopAnimating()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
            self.errorContainer.alpha = 1.0
            self.tableView.alpha = 0.0
        }, completion: { _ in
            self.errorContainer.isHidden = false
            self.tableView.isHidden = true
            self.errorLabel.text = reason
        })
    }
    
    private func renderLoading() {
        errorContainer.isHidden = true
        tableView.isHidden = true
        spinner.alpha = 0.0
        spinner.startAnimating()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.spinner.alpha = 1.0
        })
    }
    
    private func renderSuccess() {
        UIView.animate(withDuration: 0.3, animations: {
            self.spinner.alpha = 0.0
        }) { _ in
            self.spinner.stopAnimating()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
            self.errorContainer.alpha = 0.0
            self.tableView.alpha = 1.0
        }) { _ in
            self.errorContainer.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
            
            // Animación de fade-in para las celdas
            let visibleCells = self.tableView.visibleCells
            let tableViewHeight = self.tableView.bounds.size.height
            
            for (index, cell) in visibleCells.enumerated() {
                cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
                UIView.animate(withDuration: 0.6, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
                    cell.transform = .identity
                })
            }
        }
    }
    
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.heroes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroTableViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? HeroTableViewCell {
            let hero = viewModel.heroes[indexPath.row]
            cell.setAvatar(hero.photo)
            cell.setHeroName(hero.name)
        }
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let heroDetailsViewController = HeroeDetailsBuilder(id: viewModel.heroes[indexPath.row].identifier).build()
        self.navigationController?.pushViewController(heroDetailsViewController, animated: true)
    }
}
