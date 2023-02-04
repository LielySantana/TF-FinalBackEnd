//
//  UserCVC.swift
//  TikFinder
//
//  Created by krunal on 21/01/23.
//

import UIKit

class UserCVC: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    var isUnlocked: Bool?
    @IBOutlet weak var bluredView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicUrl: UIImageView!
    
    
    func blur(cell: UICollectionViewCell) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = cell.contentView.bounds
        cell.contentView.addSubview(blurView)
        
        let label = UILabel(frame: blurView.frame)
           label.text = "To view more\nunlock with 50 coins"
           label.numberOfLines = 0
           label.textAlignment = .center
           label.font = UIFont(name: "Poppins-SemiBold", size: 10)
           label.tag = 101
           label.center = blurView.center
           blurView.addSubview(label)
    }
}
