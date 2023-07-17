//
//  InputPasswordView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct InputPasswordView: View {
    
    @Binding var password: String
    let placeholder: LocalizedStringKey
    let sfSymbol: String?
    @Binding var isSecure: Bool
    
    private let textFieldLeading: CGFloat = 30
    
    var body: some View {
        if isSecure {
            SecureField(placeholder, text: $password)
                .foregroundColor(AppColors.White)
                .font(AppFonts.NeoSansBold16)
                .modifier(ShowPasswordInTextField(text: $password, isSecure: $isSecure))
                .frame(maxWidth: .infinity,
                       minHeight: 55)
                .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
                .background(
                    ZStack(alignment: .leading, content: {
                        if let systemImage = sfSymbol {
                            CustomImageViewResizable(inputImage: systemImage)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.leading, 5)
                                .foregroundColor(!password.isEmpty ? AppColors.White.opacity(0.9) : AppColors.White.opacity(0.6))
                        }
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(!password.isEmpty ? AppColors.White.opacity(0.9) : AppColors.White.opacity(0.6), lineWidth: 3)
                    })
                )
        } else {
            TextField(placeholder, text: $password)
                .foregroundColor(AppColors.White)
                .font(AppFonts.NeoSansBold16)
                .modifier(ShowPasswordInTextField(text: $password, isSecure: $isSecure))
                .frame(maxWidth: .infinity,
                       minHeight: 55)
                .padding(.leading, sfSymbol == nil ? textFieldLeading / 2 : textFieldLeading)
                .background(
                    ZStack(alignment: .leading, content: {
                        if let systemImage = sfSymbol {
                            CustomImageViewResizable(inputImage: systemImage)
                                .font(.system(size: 16, weight: .semibold))
                                .padding(.leading, 5)
                                .foregroundColor(!password.isEmpty ? AppColors.White.opacity(0.9) : AppColors.White.opacity(0.6))
                        }
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(!password.isEmpty ? AppColors.White.opacity(0.9) : AppColors.White.opacity(0.6), lineWidth: 3)
                    })
                )
        }
    }
}

struct ShowPasswordInTextField: ViewModifier {
    @Binding var text: String
    @Binding var isSecure: Bool

    public func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            if !text.isEmpty {
                Button(action: {
                    isSecure.toggle()
                }) {
                    CustomImage.init(inputImage: isSecure ? ImageConstants.Eye : ImageConstants.Close, width: 24, height: 24).foregroundColor(AppColors.White)
                }.padding(.trailing, 12)
            }
        }
    }
}

struct InputPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        InputPasswordView(password: .constant(""), placeholder: "Password", sfSymbol: "lock", isSecure: .constant(false))
            .preview(with: "Input password View with sfSymbol")
    }
}
