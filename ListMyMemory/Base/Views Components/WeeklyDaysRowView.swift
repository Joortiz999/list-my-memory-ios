//
//  WeeklyDaysRowView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 15/7/23.
//

import Foundation
import SwiftUI

struct WeeklyDaysRowView: View {
    typealias ActionHandler = () -> Void
    
    var weekDayHumanReadable: String
    var weekDay: String
    var background: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 15
    
    init(weekDayHumanReadable: String, weekDay: String, backgroundColor: Color, borderColor: Color, handler: @escaping WeeklyDaysRowView.ActionHandler) {
        self.weekDayHumanReadable = weekDayHumanReadable
        self.weekDay = weekDay
        self.background = backgroundColor
        self.border = borderColor
        self.handler = handler
    }
    
    var body: some View {
        Button (action: handler, label: {
            VStack(alignment: .leading, spacing: 5) {
                Text(weekDay).font(.system(size: 26, design: .rounded).bold())
                Text(weekDayHumanReadable).font(.system(size: 20, design: .rounded).bold())
            }
            .foregroundColor(AppColors.White)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(background)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(border, lineWidth: 4)
            )
            .cornerRadius(cornerRadius)
        }
        
    )}
}
