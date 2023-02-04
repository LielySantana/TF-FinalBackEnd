//
//  SavedVC.swift
//  TikFinder
//
//  Created by krunal on 19/01/23.
//

import UIKit

class SavedVC: UIViewController {

    @IBOutlet weak var collectionV: UICollectionView!
    let userDefaults = UserDefaults.standard
    var songSaved: [TopSongs] = []
    var songData: TopSongs!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionV.register(UINib(nibName: "SoundsCVC", bundle: nil), forCellWithReuseIdentifier: "SoundsCVC")
        
        
    }
  

  
    
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar(vc: self, titleStr: "Saved")
        
        
        songSaved = []
        let savedDict: [String:Any] = userDefaults.object(forKey: "saveSongs") as? [String: Any] ?? [:]
        print(savedDict.keys.count)
        for (_, value) in savedDict{
            do{
                songData = try JSONDecoder().decode(TopSongs.self, from: value as! Data)
                songSaved.append(songData)
                
                print(songData)
            } catch{
                print(error)
            }
        }
        print("Saved viewed loaded")
        collectionV.reloadData()
        
        
    }

}


extension SavedVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if songSaved.count > 0{
            return songSaved.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundsCVC", for: indexPath) as! SoundsCVC
        cell.layer.cornerRadius = 3
        cell.songPicCont.load(urlString: songSaved[indexPath.row].songPic)
        cell.artistNamelbl.text = songSaved[indexPath.row].artists
        cell.songNameLbl.text = songSaved[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width-42)/2, height:  (collectionView.frame.size.width-42)/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingPostVC")
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
