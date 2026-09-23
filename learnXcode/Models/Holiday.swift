//
//  weekend.swift
//  learnXcode
//
//  Created by Pablo on 21/09/2026.
//

import Foundation
import SwiftUI
//EN ESTE CASO SE DEFINE COMO STRUCT YA QUE VAMOS A TRAER LOS DATOS DE UNA API.
//YA QUE RECUPERAMOS UN JSON, DEBEMOS PONERLE EL IDENTIFICADOR CODABLE
struct Holiday: Codable, Identifiable {
    let fecha: String
    let tipo: String
    let nombre: String

    var id: String { fecha + nombre }
}

// Cada feriado calcula su propio color según su tipo
extension Holiday {
    var color: Color {
        switch tipo {
        case "inamovible": .red
        case "trasladable": .orange
        case "puente": .blue
        default: .gray
        }
    }
}
