//
//  HeroTableViewCell.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

// MARK: - Hero TableView Cell
final class HeroTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HeroTableViewCell"
    static var nib: UINib { UINib(nibName: "HeroTableViewCell", bundle: Bundle(for: HeroTableViewCell.self)) }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatar: AsyncImageView!
    @IBOutlet weak var heroName: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAvatar()
        setupContainerView()
    }
    
    // Cancela la carga de la imagen al reutilizar la celda
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.cancel()
    }
    
    // MARK: - Setters
    func setAvatar(_ avatar: String) {
        self.avatar.setImage(avatar)
    }
    
    func setHeroName(_ heroName: String) {
        self.heroName.text = heroName
    }
    
    // MARK: - Setup Avatar
    private func setupAvatar() {
        avatar.layer.cornerRadius = 10
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 1.0
        avatar.layer.borderColor = UIColor.gray.cgColor
    }
    
    // MARK: - Setup Container View
    private func setupContainerView() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.backgroundColor = UIColor.white
    }
}
