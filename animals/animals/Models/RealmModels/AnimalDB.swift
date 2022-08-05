//
//  AnimalRealm.swift
//  animals
//
//  Created by skostiuk on 05.08.2022.
//

import Foundation
import RealmSwift

class AnimalDB: Object {
    @Persisted var title: String
    @Persisted var animalDescription: String
    @Persisted var imageUrl: String
    @Persisted var status: AnimalDTOStatus
    @Persisted var order: Int
    @Persisted var facts: List<FactDB>
//    @Persisted(primaryKey: true) var id: ObjectId

    convenience init(dto: AnimalDTO) {
        self.init()
        self.title = dto.title
        self.animalDescription = dto.description
        self.imageUrl = dto.imageUrl
        self.status = dto.status
        self.order = dto.order
        let factsDB = dto.facts?.map({ fact in
            FactDB(dto: fact)
        })
        self.facts.append(objectsIn: factsDB ?? [])

    }
}

extension AnimalDB {
    var asAnimalDTO: AnimalDTO {
        return AnimalDTO(title: self.title,
                         description: self.animalDescription,
                         imageUrl: self.imageUrl,
                         status: self.status,
                         order: self.order,
                         facts: self.facts.map({ fact in
            FactDTO(fact: fact.fact, imageUrl: fact.imageUrl)
        }))
    }
}
