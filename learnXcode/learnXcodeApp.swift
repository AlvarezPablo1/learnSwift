//
//  learnXcodeApp.swift
//  learnXcode
//
//  Created by Pablo on 31/08/2026.
//

import SwiftUI
import SwiftData

@main
struct learnXcodeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: Subject.self)
    }
}

