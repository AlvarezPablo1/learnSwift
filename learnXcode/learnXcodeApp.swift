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
            ContentView()
        }
        //LE DICE A SWIFT QUE ARME UNA BASE DE DATOS TENIENDO COMO ESTRUCTURA "SUBJECT"
        .modelContainer(for: Subject.self)
    }
}



