//
//  EventDetailView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct EventDetailView: View {
//    @Environment(\.presentationMode) var presentationModes
    var body: some View {
        List {
            Section("Evento:") {
                LabeledContent {
                    Text("Event here")
                } label: {
                    Text("Evento")
                }
                
                LabeledContent {
                    Text("place here")
                } label: {
                    Text("Place")
                }
                
                LabeledContent {
                    Text("Date here")
                } label: {
                    Text("Dia de evento")
                }
            }
            Section("Descripcion:") {
                Text("descripcion de evento (opcional).")
            }
        }
        .navigationTitle("Detalle de Evento")
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventDetailView()
        }
    }
}
