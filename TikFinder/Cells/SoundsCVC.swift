//
//  SoundsCVC.swift
//  TikFinder
//
//  Created by krunal on 20/01/23.
//

import UIKit

class SoundsCVC: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var songPicCont: UIImageView!
    @IBOutlet weak var songNameLbl: UILabel!
    @IBOutlet weak var artistNamelbl: UILabel!
    var songData: TopSongs!
    var vc = HomeDetailsVC()
    var isUnlocked: Bool?
    
    var userDefaults = UserDefaults.standard

    func blur(cell: UICollectionViewCell) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = cell.contentView.bounds
        cell.contentView.addSubview(blurView)
    }
    
    
    func saveSongs(){
        var savedSongs: [String:Any] = userDefaults.object(forKey: "saveSongs") as? [String:Any] ?? [:]
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(songData)
            savedSongs[songNameLbl.text!] = data
            userDefaults.set(savedSongs, forKey: "saveSongs")
            print("Song saved")
            print(savedSongs.keys.count)

        }catch{
            print(error)
        }
    }

    func existInSavedSong(songInfo: String)->Bool{
        var savedSongDict: [String:Any] = userDefaults.object(forKey: "saveSongs") as? [String:Any] ?? [:]
        var exist = savedSongDict[songInfo]
        if(exist == nil){
            return false
        }
        return true
    }
    
    @IBAction func saveSong(_ sender: UIButton) {
        saveSongs()
        existInSavedSong(songInfo: self.songNameLbl.text!)
//        print(self.songNameLbl.text)
//        print("THIS IS THE SONG DATA THAT IM LOOKING FOR")

        
    }
    
    
}
