//
//  RootView.swift
//  learnXcode
//
//  Created by Pablo on 23/09/2026.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Query(filter: #Predicate<Subject> { $0.hasTask }) private var pending: [Subject]
    
    var body: some View {
        TabView {
            Tab("Materias", systemImage: "book") {
                SubjectView()
            }
            .badge(pending.count)
            Tab("Feriados", systemImage: "calendar") {
                NavigationStack {
                    HolidayView()
                }
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: Subject.self, inMemory: true)
}
