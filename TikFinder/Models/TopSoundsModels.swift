//
//  TopSoundsModels.swift
//  TikFinder
//
//  Created by Christina Santana on 23/1/23.
//

import Foundation

struct TopSongs: Codable{
    var name: String
    var songPic: String
    var artists: String
    
    
//    enum CodingKeys: String, CodingKey{
//        case name
//        case songPic
//        case artists
//    }
//    
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
//        songPic = try container.decodeIfPresent(String.self, forKey: .songPic) ?? ""
//        artists = try container.decodeIfPresent(String.self, forKey: .artists) ?? ""
//        // other properties
//    }

}


