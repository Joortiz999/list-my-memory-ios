//
//  PrimaryButtonComponentView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct PrimaryButtonView: View {
    
    typealias ActionHandler = () -> Void
    
    let title: LocalizedStringKey
    let background: Color
    let foreground: Color
    let border: Color
    let handler: ActionHandler
    
    private let cornerRadius: CGFloat = 30
    
    internal init(title: LocalizedStringKey, background: Color = .blue, foreground: Color = .white, border: Color = .clear, handler: @escaping PrimaryButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 50)
        })
        .background(background)
        .foregroundColor(foreground)
        .font(.system(size: 16, weight: .bold))
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 2)
        )
    }
}

struct PrimaryButtonModifier: ViewModifier {
    @Binding var isDataValid: Bool
    func body(content: Content) -> some View {
        content
            .font(AppFonts.InterSemiBold16)
            .foregroundColor(AppColors.White)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(buttonColor)
            .cornerRadius(30)
    }
    
    var buttonColor: Color {
        return isDataValid ? Color.darkTurquoise : Color.silver
    }
}
