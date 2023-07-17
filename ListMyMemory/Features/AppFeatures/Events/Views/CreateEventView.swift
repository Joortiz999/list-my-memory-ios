//
//  CreateEventView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct CreateEventView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    typealias ActionHandler = () -> Void
    var title: LocalizedStringKey
    var selection = Date()
    let handler: ActionHandler
    
    init(title: LocalizedStringKey, handler: @escaping WeeklyDaysRowView.ActionHandler) {
        self.title = title
        self.handler = handler
    }
    
    var body: some View {
        VStack {
            BaseView(title: title, backButton: true, backButtonAction: {
                ScreenNavigation().redirectToScreen(nextView: HomeView(active: .home).environmentObject(sessionService))
            }, crossButton: false, crossButtonAction: {}, mainScreen: false, containsCapsule: false, content: {
                    ScrollView{
                        Section {
                            InputTextFieldView(text: .constant(""), placeholder: Common.Hello, keyboardType: .namePhonePad, sfSymbol: nil).foregroundColor(AppColors.White)
                        }.background(Color.clear)
                        Section {
                            InputTextFieldView(text: .constant(""), placeholder: Common.Hello, keyboardType: .namePhonePad, sfSymbol: nil).foregroundColor(AppColors.White)
                        }.background(Color.clear)
                        Section{
                            DatePicker(title, selection: .constant(.now), displayedComponents: [.date]).datePickerStyle(.graphical).foregroundColor(AppColors.White)
                            
                        }.background(Color.clear)
                        Section {
                            Toggle("Recurrente", isOn: .constant(false)).foregroundColor(AppColors.White)
                        }.background(Color.clear)
                        Section {
                            TextField("", text: .constant("notas o descripcion del evento, aqui se mostraran las notas que puedan queres los usuarios agregar a sus eventos")).foregroundColor(AppColors.White)
                        }.background(Color.clear)
                        Spacer()
                        SecondaryButtonView(title: Common.OK, image: nil, imageColor: nil, handler: handler)
                    }
            })
        }
    }
}

