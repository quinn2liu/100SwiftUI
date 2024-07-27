//
//  Astronaut.swift
//  Moonshot
//
//  Created by Quinn Liu on 7/27/24.
//

import Foundation

// Codable, meaning it can be encoded into JSON
struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
