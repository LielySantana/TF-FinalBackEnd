//
//  UserModel.swift
//  TikFinder
//
//  Created by Christina Santana on 23/1/23.
//

import Foundation

struct UserModel: Codable{
    let profilePicUrl: String
    let nickname: String
    let userId: String
    let follower: Int
    let following: Int
    let likes: Int
    var commentCount: Int
}
