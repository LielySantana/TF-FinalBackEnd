//
//  HomeVC.swift
//  TikFinder
//
//  Created by krunal on 20/01/23.
//

import UIKit
import Foundation


class HomeVC: UIViewController {
    
    @IBOutlet weak var userCV: UICollectionView!
    @IBOutlet weak var liveCV: UICollectionView!
    @IBOutlet weak var soundCV: UICollectionView!
    @IBOutlet weak var searchTF: UISearchBar!
    
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var liveLbl: UILabel!
    @IBOutlet weak var soundLbl: UILabel!
    
    
    let userDefaults = UserDefaults.standard
    var searching = false
    var isFirst: Bool?
    var getTopUN = UsersVM()
    var topUnArray: [topUsers] = []
    var topSongsArray: [TopSongs] = []
    var topLivesArray: [TopLives] = []
    var savedUsers: [String:Any] = [:]
//    var savedSongs: [String:Any] = [:]
    var songData: TopSongs!
    var songName: String = ""
//    var getTopSongs = TopSongsVM()
    
    //by default nothing cliked to purchse based on this value will remove top purchase view
    var purchaseOption = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        Task.detached { [weak self] in
            await self?.getTopUsers()
            await self?.getTopSongs()
            await self?.getTopLives()
                }
        
       
        self.userCV.register(UINib(nibName: "TopUserCVC", bundle: nil), forCellWithReuseIdentifier: "TopUserCVC")
        self.liveCV.register(UINib(nibName: "LiveCVC", bundle: nil), forCellWithReuseIdentifier: "LiveCVC")
        self.soundCV.register(UINib(nibName: "TopSoundCVC", bundle: nil), forCellWithReuseIdentifier: "TopSoundCVC")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationBar(vc: self, titleStr: "Home")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        showPurchaseView(collectionV: userCV)
//        showPurchaseView(collectionV: liveCV)
//        showPurchaseView(collectionV: soundCV)
        
    }
    
    @IBAction func moreBtnPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "HomeDetailsVC") as! HomeDetailsVC
        if sender.tag == 1{
            vc.titleStr = userLbl.text!
            vc.topUser = topUnArray
        }else if sender.tag == 2{
            vc.titleStr = liveLbl.text!
            vc.topLives = topLivesArray

        }else{
            vc.titleStr = soundLbl.text!
            vc.topSongs = topSongsArray
        }
        vc.sectionNo = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showPurchaseView(collectionV:UICollectionView){
        
        var cellWeight = userCV.frame.size.width * 0.75
        if collectionV == liveCV{
            cellWeight = collectionV.frame.size.width * 0.4
        }
        
        if collectionV == soundCV{
            cellWeight = collectionV.frame.size.width * 0.7
        }
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRect(x: cellWeight+26, y: 0, width: collectionV.contentSize.width - cellWeight, height: collectionV.frame.height)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 100
        collectionV.addSubview(blurEffectView)
        
        let lbl = UILabel(frame: blurEffectView.frame)
        lbl.text = "To view more\nunlock with 50 coins"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 20)
        lbl.tag = 101
        collectionV.addSubview(lbl)
        
        let btn = UIButton(frame: lbl.frame)
        btn.addTarget(self, action: #selector(purchasePress), for: .touchUpInside)
        btn.tag = 102
        btn.accessibilityHint = "\(collectionV.tag)"
        collectionV.addSubview(btn)
        
    }
    
    
    func storeUsers(){
        var userDefaults = UserDefaults.standard
        var savedUsers: [String:Any] = userDefaults.object(forKey: "storageTopUsers") as? [String:Any] ?? [:]

        for (_,value) in savedUsers {
            do{
                let data = try JSONDecoder().decode(topUsers.self, from: value as! Data)
                topUnArray.append(data)
            }catch{
                print(error)
            }
        }
    }
    

    

    
    func getUser(userName:String) async->UserModel?{
        var users: UserModel?
        let userVM = UsersVM()
        let userId = await userVM.getUserId(userName: userName)
        
        if(userId != nil){
            let userData = await userVM.getUserData(userId: userId!)
            
            if(userData != nil){
                users = userData
            } else {
                print("Failed load of user Data")
            }
            print("This is the user ID: ", userId)
        }else{
            print("Failed load of user Ids")
        }
        return users
    }
    
    func getTopUsers() async{
        let loader = self.loader()
        let userVM = UsersVM()
        
        let topUNames = await userVM.getTopUn()
        if(topUNames != nil){
            self.topUnArray = topUNames!
            savedUsers = self.userDefaults.object(forKey: "storageTopUsers") as? [String:Any] ?? [:]
            await self.getFirstTopUsers()
            DispatchQueue.main.async{
                self.userCV.reloadData()
                print("User CV reloaded")
                self.stopLoader(loader: loader)
            }
        }else{
                print("Failed loading top users")
        }
    }

    func getFirstTopUsers() async{
        let userName = self.topUnArray[0].nickname
        let userData = await self.getUser(userName: String(userName!.dropFirst()))
        
        let unlockIndexList = [0]
       for i in unlockIndexList{
           let userName = self.topUnArray[i].nickname
           let userData = await self.getUser(userName: String(userName!.dropFirst()))
           if(userData != nil){
               self.topUnArray[i].userId = userData?.userId
               var updatedUser = self.topUnArray[i]

               updatedUser.following = userData?.following
               updatedUser.userId = userData?.userId
               updatedUser.profilePicUrl = userData?.profilePicUrl
               updatedUser.follower = userData?.follower
             
               self.topUnArray[i] = updatedUser
               print("request completed")
           }
       }
    }
    
    
    func getTopSongs() async{
        let loader = self.loader()
        let getSongs = UsersVM()
        
        let topSongNames = await getSongs.getTopSongs()
        if(topSongNames != nil){
            self.topSongsArray = topSongNames!
//            savedSongs = self.userDefaults.object(forKey: "storageTopSongs") as? [String:Any] ?? [:]
            
            print(topSongNames![1].artists)
            print("========THIS IS THE NAME THAT WE ARE LOOKING FOR ==========")
//            await self.getTopSongs()
            DispatchQueue.main.async {
//                if  DATA IS NIL SHOW AN ALERT
                self.soundCV.reloadData()
                print("Sound CV reloader")
                self.stopLoader(loader: loader)
//            print(topSongNames)
            }
        } else{
            print("Failed loading top sounds")
        }
          
    }

    func getFirstTopSong() async{
        let unlockIndexList = [0]
       for i in unlockIndexList{
           let songName = self.topSongsArray[i].name
           let songData = await self.getTopSongs()
           let songPic = self.topSongsArray[i].songPic
           let artist =  self.topSongsArray[i].artists
           if(songName != nil){
               var updatedSongs = self.topSongsArray[i]

               updatedSongs.name = songName
               updatedSongs.songPic = songPic
               updatedSongs.artists = artist
             
               self.topSongsArray[i] = updatedSongs
               print("request completed")
           }
       }
    }
    
    
    
    func getTopLives() async{
        let loader = self.loader()
        let getLives = UsersVM()
        
        let topLivesInfo = await getLives.getTopLives()
        if(topLivesInfo != nil){
            self.topLivesArray = topLivesInfo!
//            savedSongs = self.userDefaults.object(forKey: "storageTopSongs") as? [String:Any] ?? [:]
            
            print(topLivesInfo![1].userName)
            print("========THIS IS THE LIVES INFO THAT WE ARE LOOKING FOR ==========")
//            await self.getTopSongs()
            DispatchQueue.main.async {
//                if  DATA IS NIL SHOW AN ALERT
                self.liveCV.reloadData()
                print("Lives CV reloader")
                self.stopLoader(loader: loader)
//            print(topSongNames)
            }
        } else{
            print("Failed loading top sounds")
        }
          
    }

    func getFirstTopLive() async{
        let unlockIndexList = [0]
       for i in unlockIndexList{
           let userName = self.topLivesArray[i].userName
           let livesData = await self.getTopLives()
           let profilePic = self.topLivesArray[i].userProfilePic
           let liveCover =  self.topLivesArray[i].roomCoverPic
           if(userName != nil){
               var updatedLives = self.topLivesArray[i]

               updatedLives.userName = userName
               updatedLives.userProfilePic = profilePic
               updatedLives.roomCoverPic = liveCover
             
               self.topLivesArray[i] = updatedLives
               print("request completed")
           }
       }
    }
    
    
   
    
    
    @objc func purchasePress(sender:UIButton){
        if totalPoints <= 0{
            self.tabBarController?.selectedIndex = 2
            return
        }
        let alertVC = UIAlertController(title:"Unlock", message: "By confirming this, 20 coins are going to be substracted from your app wallet.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            totalPoints = totalPoints - 20
            setNavigationBar(vc: self, titleStr: "Home")
            
            if let cv = self.view.viewWithTag(Int(sender.accessibilityHint!)!) as? UICollectionView{
                
                for v in cv.subviews{
                    if v.tag >= 100{
                        v.removeFromSuperview()
                    }
                }
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
}




extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == userCV{
            if topUnArray.count > 0 {
                    return 1
            } else {
                return 0
            }
        }
        
        
        if collectionView == soundCV{
            if topSongsArray.count > 0{
                return 1
                
            } else {
                return 0
            }
        }
        
        if collectionView == liveCV{
            if topLivesArray.count > 0{
                return 1
                
            } else {
                return 0
            }
        }
        
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == liveCV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveCVC", for: indexPath) as! LiveCVC
            cell.profilePic.load(urlString: topLivesArray[indexPath.row].userProfilePic)
            cell.userName.text = self.topLivesArray[indexPath.row].userName
            cell.liveRoomPic.load(urlString: topLivesArray[indexPath.row].roomCoverPic)
            
            if(indexPath.row==0){
                cell.isUnlocked = true
            } else {
                cell.isUnlocked = false
            }
            
            return cell
        }
        
        if collectionView == soundCV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopSoundCVC", for: indexPath) as! TopSoundCVC
//            print(topSongsArray)
            cell.artistlbl.text = self.topSongsArray[indexPath.row].artists
            cell.songNamelbl.text = self.topSongsArray[indexPath.row].name
            cell.soundPicCont.load(urlString: self.topSongsArray[indexPath.row].songPic)
            if(indexPath.row==0){
                cell.isUnlocked = true

            } else {
                cell.isUnlocked = false
//                self.showPurchaseView(collectionV: soundCV)
            }
            return cell
        }

  
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopUserCVC", for: indexPath) as! TopUserCVC
            cell.userName.text = self.topUnArray[indexPath.row].nickname
            cell.likes.text = self.topUnArray[indexPath.row].likes
            if(self.topUnArray[indexPath.row].follower != nil){
                cell.followers.text = "\(self.topUnArray[indexPath.row].follower!.roundedWithAbbreviations)"
            }
            
            if(self.topUnArray[indexPath.row].following != nil){
                cell.following.text = "\(self.topUnArray[indexPath.row].following!.roundedWithAbbreviations)"
            }
                    if(self.topUnArray[indexPath.row].profilePicUrl != nil){
                        cell.profilePic.load(urlString:self.topUnArray[indexPath.row].profilePicUrl! )
            
                    }
                    cell.profilePic.setRounded()
        
            cell.userData = self.topUnArray[indexPath.row]
            
            if(indexPath.row==0){
                cell.isUnlocked = true
                
            } else {
                cell.isUnlocked = false
                self.showPurchaseView(collectionV: userCV)
            }
            return cell
       
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == liveCV{
            return CGSize(width: collectionView.frame.size.width * 0.4, height:  collectionView.frame.size.height)
        }
        
        if collectionView == soundCV{
            return CGSize(width: collectionView.frame.size.width * 0.7, height:  collectionView.frame.size.height)
        }
        
        return CGSize(width: collectionView.frame.size.width * 0.75, height:  collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let vc = storyboard?.instantiateViewController(withIdentifier: "UpcomingPostVC")
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

@available(iOS 13.0.0, *)
extension HomeVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searching = !searchBar.text!.isEmpty
        if searching{
            userLbl.text = "USERS"
            liveLbl.text = "LIVES"
            soundLbl.text = "SOUNDS"
        }else{
            userLbl.text = "TOP USERS"
            liveLbl.text = "TOP LIVES"
            soundLbl.text = "TOP SOUNDS"
        }
        
        showPurchaseView(collectionV: userCV)
        showPurchaseView(collectionV: liveCV)
        showPurchaseView(collectionV: soundCV)
        
    }
}


