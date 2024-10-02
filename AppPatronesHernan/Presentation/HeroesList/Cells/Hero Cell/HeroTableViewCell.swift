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
    
    @IBOutlet private weak var heroName: UILabel!
    @IBOutlet private weak var avatar: AsyncImageView!
    
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
}
