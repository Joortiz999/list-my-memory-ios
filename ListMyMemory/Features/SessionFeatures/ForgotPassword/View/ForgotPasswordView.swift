//
//  ForgotPasswordView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = ForgotPasswordViewModelProvider(service: ForgotPasswordServiceProvider())
    
    var body: some View {
        NavigationView {
            VStack(spacing: 36) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        CustomImageViewResizable(inputImage: ImageConstants.LeftArrow, color: AppColors.Blue.opacity(0.8)).frame(width: 40, height: 40)
                    }
                    Spacer()
                    CustomLabelString(text: "Reset Password", font: .title3.bold(), foregroundColor: AppColors.Blue.opacity(0.8))
                    Spacer()
                }
                InputTextFieldView(text: $vm.email, placeholder: "Email", keyboardType: .emailAddress, borderColor: AppColors.White, borderWidth: 3, background: vm.email.isEmpty ? Color.black.opacity(0.3) : AppColors.Black.opacity(0.1), cornerRadius: 10, sfSymbol: "envelope")
                    .foregroundColor(AppColors.Black)
                    .background(AppColors.White)
                
                PrimaryButtonView(title: "Send Password Reset", background: AppColors.Blue.opacity(0.8), foreground: AppColors.White) {
                    vm.sendPasswordReset()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    presentationMode.wrappedValue.dismiss()
                    })
                }
                
            }
            .padding(.horizontal, 26)
            .applyClose()
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView().preview(with: "Fogot Password")
    }
}
