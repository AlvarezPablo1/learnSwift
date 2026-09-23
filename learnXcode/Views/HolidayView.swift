//
//  HolidayView.swift
//  learnXcode
//

import SwiftUI

enum HolidayState {
    case loading
    case errorMsj(String)
    case holidays([Holiday])
}

struct HolidayView: View {
    @State private var state: HolidayState = .loading

    // RECUPERA EL DÍA ACTUAL
    private var today: String {
        Date.now.formatted(.iso8601.year().month().day())
    }
    // RECUPERA EL AÑO ACTUAL
    private var year: Int {
        Calendar.current.component(.year, from: .now)
    }

    var body: some View {
        Group {
            switch state {
            case .loading:
                ProgressView("Cargando...")

            case .errorMsj(let mensaje):
                ContentUnavailableView {
                    Label("No se pudo cargar", systemImage: "wifi.slash")
                } description: {
                    Text(mensaje)
                } actions: {
                    Button("Reintentar") {
                        Task { await cargar() }
                    }
                }

            case .holidays(let holidays):
                List {
                    Section("Próximos") {
                        ForEach(holidays.filter { $0.fecha >= today }) { hol in
                            HolidayRow(holiday: hol)
                        }
                    }
                    Section("Pasados") {
                        ForEach(holidays.filter { $0.fecha < today }) { hol in
                            HolidayRow(holiday: hol)
                        }
                    }
                }
            }
        }
        .navigationTitle("Feriados \(year)")
        .task { await cargar() }
        .refreshable { await cargar() }
    }

    private func cargar() async {
        state = .loading
        do {
            let datos = try await HolidayService().fetch(year: year)
            state = .holidays(datos)
        } catch {
            state = .errorMsj(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        HolidayView()
    }
}
