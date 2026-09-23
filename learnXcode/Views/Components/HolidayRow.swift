//
//  HolidayRow.swift
//  learnXcode
//
//  Created by Pablo on 23/09/2026.
//

import SwiftUI

struct HolidayRow: View {
    let holiday: Holiday

    var body: some View {
        HStack () {
            VStack(alignment: .leading, spacing: 4) {
                Text(holiday.nombre)
                    .font(.headline)
                Text(holiday.fecha)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(holiday.tipo)
                .foregroundStyle(holiday.color)
        }
    }
}
