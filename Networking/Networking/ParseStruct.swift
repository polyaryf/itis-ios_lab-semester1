//
//  ParseStruct.swift
//  Networking
//
//  Created by Полина Рыфтина on 12.11.2022.
//

import Foundation

struct JsonData: Decodable{
    let id: Int
    let first_name: String
    let avatar: URL
}

struct ParseStruct: Decodable{
    let data: [JsonData]
}
    
