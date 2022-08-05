//
//  FactDB.swift
//  animals
//
//  Created by skostiuk on 05.08.2022.
//

import Foundation
import RealmSwift

class FactDB: Object {
    @Persisted var fact: String
    @Persisted var imageUrl: String
    @Persisted var id = UUID()

    convenience init(dto: FactDTO) {
        self.init()
        self.fact = dto.fact
        self.imageUrl = dto.imageUrl
    }
}
