//
//  TopSoundCVC.swift
//  TikFinder
//
//  Created by krunal on 21/01/23.
//

import UIKit

class TopSoundCVC: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }

    @IBOutlet weak var artistlbl: UILabel!
    @IBOutlet weak var songNamelbl: UILabel!
    @IBOutlet weak var soundPicCont: UIImageView!
    
    var isUnlocked: Bool?
}
