//
//  Mission.swift
//  Moonshot
//
//  Created by Quinn Liu on 7/27/24.
//

import Foundation

struct Mission: Codable, Identifiable {
    // since this struct is made to hold data about mission, we can just put it here as a nested struct so that it makes more sense.
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    let id: Int
    // note that since not all missions have a launch date, that means we can make launchDate an optional. Codable automatically skips over optionals if they are not decoded.
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
