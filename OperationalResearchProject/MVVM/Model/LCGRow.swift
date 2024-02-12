//
//  LCG.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 28/01/2024.
//

import Foundation

/// Struct representing a row in the LCG table.
struct LCGRow: Identifiable {
    var id = UUID().uuidString
    var simulation: String
    var z: String
    var r: String
    var random: String
    var priority: String
}

/// Struct representing input parameters for the LCG calculation.
struct LCGInput {
    var valueA: Int
    var valueM: Int
    var valueC: Int
    var maxPriority: Int
    var valueIteration: Int
}
