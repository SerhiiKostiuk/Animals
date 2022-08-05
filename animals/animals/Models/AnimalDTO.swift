//
//  AnimalDTO.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import Foundation
import RealmSwift

enum AnimalDTOStatus: String, Codable, PersistableEnum {
    case free
    case paid
}

struct AnimalDTO: Codable {
    let title: String
    let description: String
    let imageUrl: String
    let status: AnimalDTOStatus
    let order: Int
    let facts: [FactDTO]?

    let id = UUID().uuidString

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl = "image"
        case status
        case order
        case facts = "content"
    }
}

enum ContentStatus {
    case free
    case paid
    case comingSoon
}

extension AnimalDTO {

    var contentType: ContentStatus {
        if facts == nil || facts?.count == 0 {
            return .comingSoon
        } else {
            switch status {
            case .free: return .free
            case .paid: return .paid
            }
        }
    }

}
