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
    var background: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 15
    
    init(eventName: String, eventDescription: String, eventPlace: String, backgroundColor: Color, borderColor: Color, handler: @escaping WeeklyDaysRowView.ActionHandler) {
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.eventPlace = eventPlace
        self.background = backgroundColor
        self.border = borderColor
        self.handler = handler
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eventName).font(.system(size: 26, design: .rounded).bold())
            Text(eventDescription).font(.system(size: 12, design: .rounded).italic())
            Text(eventPlace).font(.callout.bold())
//            Text("").font(.caption.bold())
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 4)
        )
        .overlay(alignment: .topTrailing) {
            Button(action: handler, label: {
                CustomImageViewResizable(inputImage: ImageConstants.Expand, color: AppColors.White)
                    .frame(width: 30, height: 30)
                    .padding([.top, .trailing], 10)
            }
        )}.cornerRadius(cornerRadius)
    }
}

struct EventRowView_Previews: PreviewProvider {
    static var previews: some View {
        EventRowView(eventName: "EventName", eventDescription: "Description", eventPlace: "Place", backgroundColor: AppColors.White, borderColor: AppColors.Blue, handler: {}).preview(with: "Events dashboard")
    }
}
