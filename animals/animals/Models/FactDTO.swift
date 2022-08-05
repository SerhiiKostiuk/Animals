//
//  FactDTO.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import Foundation

struct FactDTO: Codable {
    let fact: String
    let imageUrl: String
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case fact
        case imageUrl = "image"
    }
}
