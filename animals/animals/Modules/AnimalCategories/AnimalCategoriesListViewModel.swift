//
//  AnimalCategoriesListViewModel.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import Foundation
import Combine
import RealmSwift
import SwiftUI

class AnimalCategoriesListViewModel: ObservableObject {
    //MARK: - Static Properties

    static private let path =  "https://drive.google.com/uc?export=download&id=12L7OflAsIxPOF47ssRdKyjXoWbUrq4V5"

    //MARK: - @Published Properties

    @Published var models: [AnimalDTO] = []
    @Published var selectedModel: AnimalDTO?
    @Published var inProgress = false

    //MARK: - Private Properties

    private var cancellableSet: Set<AnyCancellable> = []
    private let networkClient = NetworkClient()
    private let reachability = ReachabilityManager()

    //MARK: - Public Func

    func getList() {
        inProgress = true

        guard reachability.connectionAvailable() else {
            models = getFromDB().map({ $0.asAnimalDTO }).sorted(by: { $0.order < $1.order })
            self.inProgress = false
            return
        }

        let cancellable = networkClient.getAnimalsList(path: AnimalCategoriesListViewModel.path)
            .sink { [weak self] error in
                DispatchQueue.main.async {
                    self?.inProgress = false
                }
                print(error)
            } receiveValue: {[weak self] dto in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.models = dto.sorted(by: { $0.order < $1.order })
                    self.saveToDB(dto: dto)
                    self.inProgress = false
                }
            }
        cancellableSet.insert(cancellable)
    }

    func invalidate() {
        cancellableSet.forEach { $0.cancel() }
        cancellableSet.removeAll()
    }

    //MARK: - Private Func

    private func saveToDB(dto: [AnimalDTO]) {
        let localRealm = try! Realm()
        try! localRealm.write {
            localRealm.deleteAll()
        }

        dto.forEach { animalDTO in
            try! localRealm.write({
                localRealm.add(AnimalDB(dto: animalDTO))
            })
        }
    }

    private func getFromDB() -> [AnimalDB] {
        return try! Realm().objects(AnimalDB.self).map { $0 }
    }
}
