//
//  EventRowView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct EventRowView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Evento").font(.system(size: 26, design: .rounded).bold())
            Text("descripcion de evento").font(.system(size: 12, design: .rounded).italic())
            Text("Lugar").font(.callout.bold())
            Text("").font(.caption.bold())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(alignment: .topTrailing) {
            Button {
                //TODO: Handle Delete Event Logic
            } label: {
                Image(systemName: "pin")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundColor(.red.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
    }
}

struct EventRowView_Previews: PreviewProvider {
    static var previews: some View {
        EventRowView()
    }
}
