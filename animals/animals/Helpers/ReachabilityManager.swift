//
//  ReachabilityManager.swift
//  animals
//
//  Created by skostiuk on 05.08.2022.
//

import Foundation
import Reachability

class ReachabilityManager {
    let reachability: Reachability

    init() {
        reachability = try! Reachability()
    }

    func connectionAvailable() -> Bool {
        switch reachability.connection {
        case .wifi, .cellular:
            return true
        case .unavailable:
            return false
        }
    }
}
