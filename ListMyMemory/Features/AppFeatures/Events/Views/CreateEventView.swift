//
//  CreateEventView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct CreateEventView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
        List {
            Section("Crea un nuevo evento:") {
                InputTextFieldView(text: .constant(""), placeholder: "Nombre de evento", keyboardType: .namePhonePad, sfSymbol: "flag")
                InputTextFieldView(text: .constant(""), placeholder: "Lugar de evento", keyboardType: .namePhonePad, sfSymbol: "star")
                DatePicker("Dia de evento", selection: .constant(.now),
                           displayedComponents: [.date])
                .datePickerStyle(.compact)
                Toggle("Recurrente", isOn: .constant(false))
            }
            Section("Notas") {
                TextField("", text: .constant("notas o descripcion del evento, aqui se mostraran las notas que puedan queres los usuarios agregar a sus eventos"), axis: .vertical)
            }
        }.listStyle(.plain)
            PrimaryButtonView(title: "Crear") {
                // TODO: Handle Create event
            }
            .padding(.bottom, 44)
            .padding(.horizontal, 10)
        }
        
        .navigationTitle("Event Creation")
        .applyClose()
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CreateEventView()
        }
    }
}
