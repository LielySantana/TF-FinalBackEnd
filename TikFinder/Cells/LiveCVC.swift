//
//  LiveCVC.swift
//  TikFinder
//
//  Created by krunal on 21/01/23.
//

import UIKit

class LiveCVC: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        self.profilePic.setRounded()
    }
    
    @IBOutlet weak var bluredView: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var liveRoomPic: UIImageView!
    
    var isUnlocked: Bool?
}
