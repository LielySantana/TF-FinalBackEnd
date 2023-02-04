//
//  TopUserCVC.swift
//  TikFinder
//
//  Created by krunal on 21/01/23.
//

import UIKit

class TopUserCVC: UICollectionViewCell {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var following: UILabel!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var followers: UILabel!
    var userData:topUsers!
    var isUnlocked: Bool?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.white.cgColor
        
        self.profilePic.setRounded()
    }
    
    
    
    
    
    

}
