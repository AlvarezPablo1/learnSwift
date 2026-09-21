//
//  ContentView.swift
//  learnXcode
//
//  Created by Pablo on 31/08/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //QUERY CONSULTA LA BBDD, TRAE EL ARRAY (SUBJECT EN ESTE CASO) Y SE ACTUALIZA CUANDO CAMBIA
    @Query private var subjects: [Subject]
    // CONSULTA EN LA BBDD Y FILTRA POR AQUELLOS OBJETOS CUYO "HASTASK" SEA TRUE
    @Query(filter: #Predicate<Subject> { $0.hasTask }) private var pending: [Subject]
    //SIRVE PARA LUEGO PODER MODIFICAR LOS VALORES GUARDADOS EN EL CONTEXTO, EN ESTE CASO SUBJECT
    @Environment(\.modelContext) private var context
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("Materias") {
                    ForEach(subjects) { sub in
                        NavigationLink {
                            DetalleView(subject: sub)
                        } label: {
                            Text(sub.type)
                                .font(.headline)
                                .foregroundStyle(sub.hasTask ? .red : .green)
                        }
                    }
                    .onDelete(perform: borrar)
                }
                Section("Tareas (\(pending.count) pendientes)") {
                    ForEach(pending) { pen in
                        Button {
                            withAnimation(.smooth) {
                                pen.hasTask.toggle()
                            }
                        } label: {
                            HStack {
                                Text(pen.type)
                                Spacer()
                                Image(systemName: "circle")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Carreras")
            .toolbar {
                Button("Agregar", systemImage: "plus", action: agregar)
                EditButton()
            }
        }
    }

    //MODIFICA EL CONTEXTO AGREGANDO UN OBJETO NUEVO
    private func agregar() {
        context.insert(Subject(type: "Nueva"))
    }
    //MODIFICA EL CONTEXTO ELIMINANDO UN OBJETO
    private func borrar(_ offsets: IndexSet) {
        for i in offsets {
            context.delete(subjects[i])
        }	
    }
}
#Preview {
    ContentView()
        .modelContainer(for: Subject.self, inMemory: true)
}
