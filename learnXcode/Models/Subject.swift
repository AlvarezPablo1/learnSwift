//
//  Subject.swift
//  learnXcode
//
//  Created by Pablo on 17/09/2026.
//

import SwiftData

//CONVIERTE UNA CLASE EN ALGO GUARDABLE
@Model
class Subject {
    //COMO AHORA FUNCIONA CON SWIFTDATA, NO HACE FALTA NINGUN INTERFACE (IDENTIFICABLE, CODEABLE, ETC) POR LO QUE TAMPOCO HACE FALTA ESCRIBIR EL CAMPO "ID"
    var type: String
    var hasTask: Bool
    
    init(type: String, hasTask: Bool = false) {
           self.type = type
           self.hasTask = hasTask
       }
}
