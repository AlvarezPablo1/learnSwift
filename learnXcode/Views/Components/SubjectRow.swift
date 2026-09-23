//
//  Subject.swift
//  learnXcode
//
//  Created by Pablo on 23/09/2026.
//


import SwiftUI

struct SubjectRow: View {
    let subject: Subject

    var body: some View {
        HStack {
            Text(subject.type)
                .font(.headline)
            Spacer()
            if subject.hasTask {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    List {
        SubjectRow(subject: Subject(type: "Historia", hasTask: true))
        SubjectRow(subject: Subject(type: "Lengua"))
    }
}
