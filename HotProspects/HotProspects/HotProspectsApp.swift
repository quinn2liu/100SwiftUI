//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Quinn Liu on 8/4/24.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
