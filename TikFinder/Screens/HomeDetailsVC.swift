//
//  HomeDetailsVC.swift
//  TikFinder
//
//  Created by krunal on 21/01/23.
//

import UIKit

class HomeDetailsVC: UIViewController {
    
    @IBOutlet weak var collectionV: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    var titleStr = ""
    var sectionNo = 1
    
    
    var topSongs: [TopSongs] = []
    var topUser: [topUsers] = []
    var topLives: [TopLives] = []
    
    
    var songData: TopSongs!
    var songName: String = ""
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = titleStr
        self.collectionV.register(UINib(nibName: "SoundsCVC", bundle: nil), forCellWithReuseIdentifier: "SoundsCVC")
        self.collectionV.register(UINib(nibName: "LiveCVC", bundle: nil), forCellWithReuseIdentifier: "LiveCVC")
        self.collectionV.register(UINib(nibName: "UserCVC", bundle: nil), forCellWithReuseIdentifier: "UserCVC")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBarDetail(titleStr: "Home")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        showPurchaseView()
    }
    
    @objc func backPress(){
        self.navigationController?.popViewController(animated: true)
    }
    
//    func showPurchaseView(){
//
//        var cellHeight = (collectionV.frame.size.width-42)/1.5
//        if sectionNo == 1{
//            cellHeight = 60
//        }
//
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = CGRect(x: 16, y: cellHeight + 10, width: collectionV.frame.size.width - 32, height: collectionV.contentSize.height - cellHeight)
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurEffectView.tag = 100
//        collectionV.addSubview(blurEffectView)
//
//        let lbl = UILabel(frame: blurEffectView.frame)
//        lbl.text = "To view more\nunlock with 50 coins"
//        lbl.numberOfLines = 0
//        lbl.textAlignment = .center
//        lbl.font = UIFont(name: "Poppins-SemiBold", size: 20)
//        lbl.tag = 101
//        collectionV.addSubview(lbl)
//
//        let btn = UIButton(frame: lbl.frame)
//        btn.addTarget(self, action: #selector(purchasePress), for: .touchUpInside)
//        btn.tag = 102
//        collectionV.addSubview(btn)
//
//    }
    
    
    func toggleBlur(on cell: UICollectionViewCell) {
        if let blurView = cell.contentView.subviews.first(where: { $0 is UIVisualEffectView }) {
            blurView.removeFromSuperview()
        } else {
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = cell.contentView.bounds
            cell.contentView.addSubview(blurView)
        }
    }
    
    @objc func purchasePress(){
        if totalPoints <= 20{
            self.tabBarController?.selectedIndex = 2
            return
        }
        let alertVC = UIAlertController(title:"Unlock", message: "By confirming this, 20 coins are going to be substracted from your app wallet.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            totalPoints = totalPoints - 50
            self.setNavigationBarDetail(titleStr: "Home")
            
            for v in self.collectionV.subviews{
                if v.tag >= 100{
                    v.removeFromSuperview()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    
   
    
    
    
    
    
    
    func setNavigationBarDetail(titleStr:String){
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(backPress), for: .touchUpInside)
        let img = UIBarButtonItem(customView: btn)
        
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 15
        
        
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.text = titleStr
        titleLbl.font = UIFont(name: "Montserrat-ExtraBold", size: 40)
        
        let leftBarItem = UIBarButtonItem(customView: titleLbl)
        //        vc.navigationItem.leftBarButtonItem = leftBarItem
        
        self.navigationItem.leftBarButtonItems = [space,img,leftBarItem]
        
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        v.backgroundColor = UIColor.darkGray
        v.layer.cornerRadius = 5.0
        
        let dollImg = UIImageView(frame: CGRect(x: 10, y: 7, width: 16, height: 16))
        dollImg.image =  UIImage(named: "coin")
        dollImg.tintColor = UIColor.white
        v.addSubview(dollImg)
        
        let lbl = UILabel(frame: CGRect(x: 32, y: 3, width: 40, height: 24))
        lbl.textColor = UIColor.white
        lbl.text = "\(totalPoints)"
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 19)
        v.addSubview(lbl)
        
        let barItem = UIBarButtonItem(customView: v)
        self.navigationItem.rightBarButtonItem = barItem
        
    }
    
}


extension HomeDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sectionNo == 1{
            if topUser.count > 0 {
                return topUser.count
            } else {
                return 0
            }
        }
        
        if sectionNo == 2{
            if topLives.count > 0{
                return topLives.count
                
            } else {
                return 0
            }
        }
        
        if sectionNo == 3{
            if topSongs.count > 0{
                return 50
                
            } else {
                return 0
            }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if sectionNo == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCVC", for: indexPath) as! UserCVC
            cell.blur(cell: cell)
            
            cell.userName.text = topUser[indexPath.row].nickname
       
            if(self.topUser[indexPath.row].profilePicUrl != nil){
                cell.profilePicUrl.load(urlString:self.topUser[indexPath.row].profilePicUrl! )
            
                    }
            cell.profilePicUrl.setRounded()
            return cell
        }
        
        if sectionNo == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCVC", for: indexPath) as! LiveCVC
            cell.userName.text = topLives[indexPath.row].userName
       
            if(self.topLives[indexPath.row].userProfilePic != nil){
                cell.profilePic.load(urlString:self.topLives[indexPath.row].userProfilePic)
            
                    }
            
            if(self.topLives[indexPath.row].roomCoverPic != nil){
                cell.liveRoomPic.load(urlString:self.topLives[indexPath.row].roomCoverPic)
            
                    }
            cell.profilePic.setRounded()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundsCVC", for: indexPath) as! SoundsCVC
        cell.layer.cornerRadius = 3
        cell.artistNamelbl.text = topSongs[indexPath.row].artists
        cell.songNameLbl.text = topSongs[indexPath.row].name
        cell.songPicCont.load(urlString: topSongs[indexPath.row].songPic)
        cell.songData = topSongs[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sectionNo == 1{
            return CGSize(width: (collectionView.frame.size.width-42)/2, height:  60)
        }
        return CGSize(width: (collectionView.frame.size.width-42)/2, height:  (collectionView.frame.size.width-42)/1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if sectionNo == 1{
            guard let cell = collectionView.cellForItem(at: indexPath) as? UserCVC
            else{
                return
            }
            
                if(totalPoints<50){
                   purchasePress()
                    return
                }
            
            cell.userName.text = topUser[indexPath.row].nickname
            if(self.topUser[indexPath.row].profilePicUrl != nil){
                cell.profilePicUrl.load(urlString:self.topUser[indexPath.row].profilePicUrl! )
            
                    }
            cell.profilePicUrl.setRounded()
                    }
        
//        if sectionNo == 2{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCVC", for: indexPath) as! LiveCVC
//            cell.userName.text = topLives[indexPath.row].userName
//
//            if(self.topLives[indexPath.row].userProfilePic != nil){
//                cell.profilePic.load(urlString:self.topLives[indexPath.row].userProfilePic)
//
//                    }
//
//            if(self.topLives[indexPath.row].roomCoverPic != nil){
//                cell.liveRoomPic.load(urlString:self.topLives[indexPath.row].roomCoverPic)
//
//                    }
//            cell.profilePic.setRounded()
//            return cell
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundsCVC", for: indexPath) as! SoundsCVC
//        cell.layer.cornerRadius = 3
//        cell.artistNamelbl.text = topSongs[indexPath.row].artists
//        cell.songNameLbl.text = topSongs[indexPath.row].name
//        cell.songPicCont.load(urlString: topSongs[indexPath.row].songPic)
//        cell.songData = topSongs[indexPath.row]
//        return cell
//    }
    }
    
    
}
