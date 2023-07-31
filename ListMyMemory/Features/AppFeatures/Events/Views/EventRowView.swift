//
//  EventRowView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct EventRowView: View {
    typealias ActionHandler = () -> Void
    
    var eventName: String
    var eventDescription: String
    var eventPlace: String
    var eventDate: String
    var background: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 15
    
    init(eventName: String, eventDescription: String, eventPlace: String, eventDate: String, backgroundColor: Color, borderColor: Color, handler: @escaping WeeklyDaysRowView.ActionHandler) {
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.eventPlace = eventPlace
        self.eventDate = eventDate
        self.background = backgroundColor
        self.border = borderColor
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(eventName).font(.system(size: 26, design: .rounded).bold()).foregroundColor(AppColors.Black).frame(maxWidth: .infinity, alignment: .leading)
                Text(eventDescription).font(.system(size: 14, design: .rounded).bold()).foregroundColor(AppColors.White).shadow(radius: 2)
                HStack{
                    Text(eventPlace).font(.system(size: 16, design: .rounded).bold()).foregroundColor(AppColors.Black)
                    Spacer()
                    Text(eventDate).font(.system(size: 16, design: .rounded).bold()).foregroundColor(AppColors.Black).underline()
                }
                
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(background)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(border, lineWidth: 4)
            )
            .overlay(alignment: .topTrailing) {
                CustomImageViewResizable(inputImage: ImageConstants.Expand, color: AppColors.White)
                    .frame(width: 30, height: 30)
                    .padding([.top, .trailing], 10)
                
            }.cornerRadius(cornerRadius)
        })
    }
}
