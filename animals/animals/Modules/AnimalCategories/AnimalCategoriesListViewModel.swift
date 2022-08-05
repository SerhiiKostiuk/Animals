//
//  AnimalCategoriesListViewModel.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import Foundation

class AnimalCategoriesListViewModel: ObservableObject {
    //MARK: - Static Properties

    static private let path =  "https://drive.google.com/uc?export=download&id=12L7OflAsIxPOF47ssRdKyjXoWbUrq4V5"

    //MARK: - @Published Properties

    @Published var models: [AnimalDTO] = []

    //MARK: - Private Properties

    private var cancellableSet: Set<AnyCancellable> = []
    private let networkClient = NetworkClient()

    func getList() {
        let cancellable = networkClient.getAnimalsList(path: AnimalFactsViewModel.path)
            .sink { error in
                print(error)
            } receiveValue: {[weak self] dto in
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    self.models = dto.sorted(by: { $0.order < $1.order })
                }
            }
        cancellableSet.insert(cancellable)
    }

    func invalidate() {
        cancellableSet.forEach { $0.cancel() }
        cancellableSet.removeAll()
    }
}
