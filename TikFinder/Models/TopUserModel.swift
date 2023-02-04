//
//  TopUserModel.swift
//  TikFinder
//
//  Created by Christina Santana on 23/1/23.
//

import Foundation

struct topUsers: Codable{
    var profilePicUrl: String?
    var nickname: String?
    var userId: String?
    var follower: Int?
    var following: Int?
    var likes: String?
}

//struct topUnModel: Codable {
//    let nickname: String
//    
//    
//    enum CodingKeys: String, CodingKey{
//        case nickname
//}
//
//typealias UserListModel = [topUnModel]
//
//
//    
//    init(from decoder: Decoder) throws {
//        var container = try decoder.container(keyedBy: CodingKeys.self)
//        self.nickname = try container.decode(String.self, forKey: .nickname)
//        
//    }




