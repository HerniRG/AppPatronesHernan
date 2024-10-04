//
//  HeroTableViewCell.swift
//  AppPatronesHernan
//
//  Created by Hernán Rodríguez on 1/10/24.
//

import UIKit

final class HeroTableViewCell: UITableViewCell {
    static let reuseIdentifier = "HeroTableViewCell"
    static var nib: UINib { UINib(nibName: "HeroTableViewCell", bundle: Bundle(for: HeroTableViewCell.self)) }
    
    
    @IBOutlet weak var avatar: AsyncImageView!
    @IBOutlet weak var heroName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAvatar()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatar.cancel()
    }
    
    func setAvatar(_ avatar: String) {
        self.avatar.setImage(avatar)
    }
    
    func setHeroName(_ heroName: String) {
        self.heroName.text = heroName
    }
    
    // Configuración del avatar con bordes redondeados
    private func setupAvatar() {
        avatar.layer.cornerRadius = 10
        avatar.layer.masksToBounds = true
        avatar.layer.borderWidth = 1.0
        avatar.layer.borderColor = UIColor.gray.cgColor
    }
}
