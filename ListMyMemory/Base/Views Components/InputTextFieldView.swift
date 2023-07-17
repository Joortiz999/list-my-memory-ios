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
    let sfSymbol: String?
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        TextField(self.placeholder, text: $text)
            .foregroundColor(AppColors.White)
            .font(AppFonts.NeoSansBold16)
                .frame(maxWidth: .infinity,
                       minHeight: 55)
                .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
                .keyboardType(keyboardType)
                .background(
                    ZStack(alignment: .leading, content: {
                        if let systemImage = sfSymbol {
                            Image(systemName: systemImage)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.leading, 5)
                                .foregroundColor(!text.isEmpty ? AppColors.White.opacity(0.9) : AppColors.White.opacity(0.6))
                        }
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(!text.isEmpty ? AppColors.White.opacity(0.9) : AppColors.White.opacity(0.6), lineWidth: 3)
                    })
                )
    }
}

struct InputTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InputTextFieldView(text: .constant("email.mail@mail.com"), placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                .preview(with: "Text Input Edit with sfsymbol")
            
            InputTextFieldView(text: .constant(""),placeholder: "First Name", keyboardType: .default, sfSymbol: nil)
                .preview(with: "Text Input without sfsymbol")
        }
    }
}
