//
//  DetalleView.swift
//  learnXcode
//
//  Created by Pablo on 14/09/2026.
//

import SwiftUI

struct DetalleView: View {
    @Bindable var subject: Subject

    var body: some View {
        Form {
            TextField("Título", text: $subject.type)
            Toggle("Tarea pendiente", isOn: $subject.hasTask)
        }
        .navigationTitle("Editar")
    }
}
