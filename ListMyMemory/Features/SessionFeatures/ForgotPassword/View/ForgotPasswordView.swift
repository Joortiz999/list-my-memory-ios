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
            
            VStack(spacing: 16) {
                InputTextFieldView(text: $vm.email, placeholder: "Email", keyboardType: .emailAddress, borderColor: AppColors.White, borderWidth: 3, cornerRadius: 10, sfSymbol: "envelope")
                    .foregroundColor(AppColors.Black)
                    .background(AppColors.White)
                
                PrimaryButtonView(title: "Send Password Reset") {
                    vm.sendPasswordReset()
                    presentationMode.wrappedValue.dismiss()
                }
                
            }
            .padding(.horizontal, 16)
            .navigationTitle("Reset Password")
            .applyClose()
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView().preview(with: "Fogot Password")
    }
}
