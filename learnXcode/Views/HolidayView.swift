//
//  HolidayView.swift
//  learnXcode
//
//  Created by Pablo on 21/09/2026.
//

import SwiftUI

struct HolidayView: View {
    @State private var holidays: [Holiday] = []
    @State private var loading = false
    @State private var errorMsj: String?
    // RECUPERA EL DÍA ACTUAL
    private var today: String {
        Date.now.formatted(.iso8601.year().month().day())
    }
    // RECUPERA EL AÑO ACTUAL
    private var year: Int {
        Calendar.current.component(.year, from: .now)
    }
    //FILTRA Y GUARDA LOS PROXIMOS FERIADOS
    private var nextHoliday: [Holiday] {
        holidays.filter{$0.fecha >= today}
    }
    //FILTRA Y GUARDA LOS FERIADOS PASADOS
    private var LastHoliday: [Holiday] {
        holidays.filter{$0.fecha < today}
    }
    
    var body: some View {
        //FORMATO EN EL QUE SE VAN A VER LOS FERIADOS
        List{
            Section("Proximos"){
                ForEach(nextHoliday) { newHol in
                    HStack () {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(newHol.nombre)
                                .font(.headline)
                            Text(newHol.fecha)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(newHol.tipo)
                            .foregroundStyle(newHol.color)
                    }
                }
            }
            Section("Pasados"){
                ForEach(LastHoliday) { lastHol in
                    HStack () {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(lastHol.nombre)
                                .font(.headline)
                            Text(lastHol.fecha)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(lastHol.tipo)
                            .foregroundStyle(lastHol.color)
                    }
                }
            }
            
            
            
        }
        //MUESTRA INFORMACION ADELANTE POR ENCIMA DE LO QUE TIENE LA VISTA, EN ESTE CASO EL LOADING MIENTRAS ESTE CARGANDO O EL MSJ DE ERROR SI ES QUE FALLA
        .overlay {
            if loading && holidays.isEmpty {
                ProgressView("Cargando...")
            } else if let errorMsj {
                ContentUnavailableView {
                    Label("No se pudo cargar", systemImage: "wifi.slash")
                } description: {
                    Text(errorMsj)
                } actions: {
                    Button("Reintentar") {
                        Task { await cargar() }
                    }
                }
            }
        }
        //TITULO DE LA VISTA
        .navigationTitle("Feriados 2026")
        //HACE QUE SE "ACTIVE" EL LLAMADO A LA API, SI EL USUARIO VIAJA A OTRA PANTALLA MIENTRAS ESTA LLAMANDO AL SERVICIO, CORTA EL LLAMADO SIN GENERAR PROBLEMAS
        .task { await cargar() }
        //SI EL USUARIO RECARGA LA PAGINA VUELVE A LLAMARSE AL SERVICIO
        .refreshable { await cargar() }
    }

    //FUNCION LA CUAL HACE EL LLAMADO AL SERVICIO Y LO GUARDA EN LA VARIABLE "HOLIDAYS". POR OTRO LADO SI FALLA, GUARDA EL ERROR EN LA VARIABLE "ERRORMSJ" Y POR ULTIMO TAMBIEN MANEJA EL LOADING
    private func cargar() async {
        loading = true
        //PARECIDO AL "FINALLY", SE EJECUTA CUANDO TERMINA EL ASYNC
        defer { loading = false }

        do {
            holidays = try await HolidayService().fetch(year: year)
            errorMsj = nil
        } catch {
            errorMsj = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        HolidayView()
    }
}
