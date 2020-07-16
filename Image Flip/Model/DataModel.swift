//
//  DataModel.swift
//  Image Flip
//
//  Created by Muhammad Arif Hidayatulloh on 02/07/20.
//  Copyright © 2020 Ardat Code. All rights reserved.
//

import Foundation

struct DataModel : Codable {
    let data : Memes?
    
    struct Memes : Codable {
        let memes : [DataMemes]?
    }
    
    struct DataMemes : Codable {
        let id : String?
        let name : String?
        let url : String?
        let width : Int?
        let height : Int?
        let box_count : Int?
    }
}
