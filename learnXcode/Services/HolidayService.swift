//
//  HolidayService.swift
//  learnXcode
//
//  Created by Pablo on 21/09/2026.
//

import Foundation

struct HolidayService {
    func fetch(year: Int) async throws -> [Holiday] {
        //URL DE LA API A LA QUE LE PASAMOS COMO PARAM EN ESTE CASO EL AÑO (YEAR)
        let url = URL(string: "https://api.argentinadatos.com/v1/feriados/\(year)")!

        //RECUPERAMOS LA DATA Y EL RESPONSE DEL LLAMADO A LA API
        let (data, response) = try await URLSession.shared.data(from: url)

        //PRIMERO VALIDAMOS QUE EL RESPONSE SEA UN 200, SI NO LO ES VA AL THROW
        //EL "HTTPURLResponse" SIRVE PARA TRANSFORMAR DICHA RESPONSE EN UN FORMATO "HTTP"
        //POR SI SOLO "URLSession" NO DISTINGUE LOS STATUS DE LOS SERVICIOS, POR ESO HAY QUE ACLARARLOS MANUALMENTE, COMO ACA QUE VALIDAMOS QUE SEA 200 O NO
        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        //TRANSFORMA LA DATA QUE RECUPERAMOS DE LA API CON EL ".DECODE" A UN FORMATO QUE PODAMOS RENDERIZAR
        return try JSONDecoder().decode([Holiday].self, from: data)
    }
}
