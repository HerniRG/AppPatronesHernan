//
//  HeroesListViewController.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

final class HeroesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorContainer: UIStackView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    private let viewModel: HeroesListViewModel
    
    init(viewModel: HeroesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HeroesListView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(HeroTableViewCell.nib, forCellReuseIdentifier: HeroTableViewCell.reuseIdentifier)
        
        configureNavigationBar(title: "Heroes", backgroundColor: .systemIndigo)
        bind()
        viewModel.load()
    }
    
    @IBAction func onRetryTapped(_ sender: Any) {
    }
    
    
    // MARK: - States
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let heroDetailsViewController = HeroeDetailsBuilder().build(with: viewModel.heroes[indexPath.row])
        
        navigationController?.pushViewController(heroDetailsViewController, animated: true)
    }


}
