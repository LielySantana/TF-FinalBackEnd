//
//  TopUserVM.swift
//  TikFinder
//
//  Created by Christina Santana on 23/1/23.
//

import Foundation
import UIKit

struct UsersVM{
    
    @available(iOS 13.0.0, *)
    func callAPI(urlRequest:URLRequest)async throws ->(Data?, URLResponse?){
        print("requested$$$$$$$$$$$$$$$$$$")
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard response is HTTPURLResponse else {
            return (nil,nil)
        }
        return (data,response)
    }
    
    @available(iOS 13.0.0, *)
    func getUserId(userName: String) async ->String?{
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "tokapi-mobile-version.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(userName)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 30.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(userName)")
        let session = URLSession.shared
        
        do {
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            
            do{
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                
                var userId = jsonData.value(forKey: "uid") as? String
                
                //                      //print(userId)
                //                        print("======================USER ID VM===================================")
                return userId
            }catch{
               return nil
            }
        } catch  {
            print(error)
            return nil
        }
    }
    
    @available(iOS 13.0.0, *)
    func searchUsers(userName: String) async ->[SearchUserModel]?{
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "scraptik.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://scraptik.p.rapidapi.com/search-users?keyword=\(userName)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 30.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://scraptik.p.rapidapi.com/search-users?keyword=\(userName)")
        let session = URLSession.shared
        
        do {
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            
            do{
                var searchUserList:[SearchUserModel] = []
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                
                if let userList = jsonData.value(forKey: "user_list") as! [NSDictionary]? {
                    for user in userList {
                        let userInfo = user.object(forKey: "user_info") as! NSDictionary
                        let picInfo = userInfo.object(forKey: "avatar_168x168") as! NSDictionary
                        let picUrl = picInfo.object(forKey: "url_list") as! [String]
                        
                        
                        
                        let id = userInfo.object(forKey: "uid") as! String
                        let nickName = userInfo.object(forKey: "unique_id") as! String
                        let searchUser = SearchUserModel(profilePicUrl:picUrl[0], nickname: nickName, userId: id)
                        searchUserList.append(searchUser)
                    }
                }
                return searchUserList
            }catch{
               return nil
            }
        } catch  {
            print(error)
            return nil
        }
    }
    
    @available(iOS 13.0.0, *)
    func getTopUn()async ->[topUsers]?{
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "tiktok-tops.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tiktok-tops.p.rapidapi.com/top-users/50/us")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 5.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://tiktok-tops.p.rapidapi.com/top-users/50/us")
        let session = URLSession.shared
        
        do {
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            
            do{
                let result = try JSONDecoder().decode([topUsers].self, from: data!)
                return result
            }catch{
                return nil
            }
        } catch  {
            print(error)
            return nil
        }
        
    }
    
    
    
    
    
    @available(iOS 13.0.0, *)
    func getUserData(userId: String)async ->UserModel?{
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "tokapi-mobile-version.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://tokapi-mobile-version.p.rapidapi.com/v1/user/\(userId)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://tokapi-mobile-version.p.rapidapi.com/v1/user/username/\(userId)")
        let session = URLSession.shared
        
        do {
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            
            do{
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                
                var userInfo = jsonData.value(forKey: "user") as? NSDictionary
                var profilePic = userInfo!.value(forKey: "avatar_168x168") as? NSDictionary
                var picUrl: [String] = profilePic!.value(forKey: "url_list") as! [String]
                
                var userId = userInfo!.value(forKey: "uid") as? String
                var nickname = userInfo!.value(forKey: "unique_id") as? String
                
                
                var followers = userInfo!.value(forKey: "follower_count") as? Int
                var following = userInfo!.value(forKey: "following_count") as? Int
                var likes = userInfo!.value(forKey: "total_favorited") as? Int
                
                var topUserData: UserModel = UserModel(profilePicUrl: picUrl[0], nickname: nickname!, userId: userId!, follower: followers!, following: following!, likes: likes!, commentCount: 0)
                
                print(topUserData)
                print("======================USER DATA VM===================================")
                return topUserData
            }catch{
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    
    
    @available(iOS 13.0.0, *)
    func getTopSongs() async ->[TopSongs]?{
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "spotify81.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://spotify81.p.rapidapi.com/top_200_tracks?country=GLOBAL")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://spotify81.p.rapidapi.com/top_200_tracks")
        let session = URLSession.shared
        var songsArray: [TopSongs] = []
        
        do {
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            if let httpResponse =  response as? HTTPURLResponse{
                print(httpResponse.statusCode)
            }
            do{
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [NSDictionary]
                
                
                if (jsonData != nil){
                    
                    for trackInfo in jsonData!{
                        var trackMeta = trackInfo.value(forKey: "trackMetadata") as? NSDictionary
                        var songName = trackMeta?.value(forKey: "trackName") as? String
                        var songPicUrl = (trackMeta?.value(forKey: "displayImageUri") as? String)
                        
                        var artistInfo = trackMeta?.value(forKey: "artists") as? [NSDictionary]
                        
                        var names = ""
                        for artistsNames in artistInfo!{
                            var currentName = artistsNames.value(forKey: "name") as! String
                            
                            names += "\(currentName) "
                            
                            
                        }
                        
                        var topSongModel: [TopSongs] = [TopSongs(name: songName!,  songPic: songPicUrl!, artists: names)]
                        
                        songsArray.append(contentsOf: topSongModel)
                    }
                } else {
                    return nil
                }
                
                


            } catch{
                return nil
            }
            
       
        } catch  {
            print(error)
            return nil
        }
        
        return songsArray
    }
    
    
    
    
    
    
    
    
    func getTopLives() async ->[TopLives]?{
        
        let headers = [
            "X-RapidAPI-Key": "e9a9788f52msh4c925f222a786e6p1ec230jsnfad6eceba839",
            "X-RapidAPI-Host": "scraptik.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://scraptik.p.rapidapi.com/search-lives?keyword=trending&count=20&offset=0")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print("https://scraptik.p.rapidapi.com/search-lives?keyword=trending&count=20&offset=0")
        let session = URLSession.shared
        var livesArray: [TopLives] = []
        
        do {
            let (data,response) = try await callAPI(urlRequest: request as URLRequest)
            if(data==nil){
                print("Server error$$$$$$$$$$$$$$$$$$$$$$$$")
                return nil
            }
            if let httpResponse =  response as? HTTPURLResponse{
                print(httpResponse.statusCode)
            }
            do{
                var jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                
                
                if (jsonData != nil){
                    
                    var dataInfo = jsonData.value(forKey: "data") as! [NSDictionary]
                    
                    for livesInfo in dataInfo{
                        
                        var lives = livesInfo.value(forKey: "lives") as! NSDictionary
                        var author = lives.value(forKey: "author") as! NSDictionary
                        var avatarPic = author.value(forKey: "avatar_larger") as! NSDictionary
                        var profilePic = avatarPic.value(forKey: "url_list") as! [String]
                        var userName = author.value(forKey: "nickname") as? String
                        var roomCover = author.value(forKey: "room_cover") as! NSDictionary
                        var roomUrl = roomCover.value(forKey: "url_list") as? [String]
                        
                        
                        var topLivesModel: [TopLives] = [TopLives(userProfilePic: profilePic[0], userName: userName!, roomCoverPic: roomUrl![0])]
                        
                        livesArray.append(contentsOf: topLivesModel)
                        print(livesArray)
                        print("===============TOP LIVES DATA===========================")
                    }
                } else {
                    return nil
                }
                
                


            } catch{
                return nil
            }
            
       
        } catch  {
            print(error)
            return nil
        }
        
        return livesArray
    }
   
    
}

    
    

        
    



