//
//  NetworkClient.swift
//  animals
//
//  Created by skostiuk on 04.08.2022.
//

import Foundation
import Combine

enum ApiError: Error {
    case somethingWentWrong
}

protocol ApiClient {
    func getAnimalsList(path: String) -> AnyPublisher<[AnimalDTO], Error>
}

final class NetworkClient: ApiClient {

    func getAnimalsList(path: String) -> AnyPublisher<[AnimalDTO], Error> {

        return AnyPublisher(Future { promise in
            guard let url = URL(string: path) else {
                promise(.failure(ApiError.somethingWentWrong))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let urlResponse = response as? HTTPURLResponse else {
                    promise(.failure(ApiError.somethingWentWrong))
                    return
                }

                if urlResponse.statusCode == 200,
                   let dto = try? JSONDecoder().decode([AnimalDTO].self, from: data)  {

                    promise(.success(dto))

                } else {
                    promise(.failure(ApiError.somethingWentWrong))
                }
            }

            task.resume()

        })

    }
}
