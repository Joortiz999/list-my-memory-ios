//
//  InputTextFieldView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct InputTextFieldView: View {
    @Binding var text: String
    let placeholder: LocalizedStringKey
    let keyboardType: UIKeyboardType
    let borderColor: Color
    let borderWidth: CGFloat
    let background: Color
    let cornerRadius: CGFloat
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        TextField(self.placeholder, text: $text)
            .foregroundColor(AppColors.Black)
            .font(.body.bold())
                .frame(maxWidth: .infinity,
                       minHeight: 55)
                .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
                .keyboardType(keyboardType)
                .background(background)
                .background(
                    ZStack(alignment: .leading, content: {
                        if let systemImage = sfSymbol {
                            Image(systemName: systemImage)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.leading, 5)
                                .foregroundColor(!text.isEmpty ? borderColor : borderColor.opacity(0.9))
                        }
                        RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                            .stroke(!text.isEmpty ? borderColor : borderColor.opacity(0.8), lineWidth: borderWidth)
                    })
                ).cornerRadius(cornerRadius)
    }
}


struct LargeInputTextFieldView: View {
    @Binding var text: String
    let placeholder: LocalizedStringKey
    let keyboardType: UIKeyboardType
    let borderColor: Color
    let borderWidth: CGFloat
    let cornerRadius: CGFloat
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        
        TextField(self.placeholder, text: $text, axis: .vertical)
            .foregroundColor(AppColors.Black)
            .font(.body.bold())
            .frame(maxWidth: 320, minHeight: 75, alignment: .topLeading)
            .autocorrectionDisabled()
            .padding([.leading], textFieldLeading / 2)
            .padding([.top], textFieldLeading / 2)
            .keyboardType(keyboardType)
            .background(AppColors.White)
            .background(
                ZStack(alignment: .leading, content: {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
                        .stroke(!text.isEmpty ? borderColor : borderColor.opacity(0.8), lineWidth: borderWidth)
                })
            ).cornerRadius(cornerRadius)
    }
}
