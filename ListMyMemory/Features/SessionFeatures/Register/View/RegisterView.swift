//
//  RegisterView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var vm = RegistrationViewModelProvider(service: RegistrationServiceProvider())
    @State private var isSecure = true
    var body: some View {
        BaseView(title: Registration.Title, backButton: true, backButtonAction: {
            ScreenNavigation().redirectToScreen(nextView: LoginView())
        }, crossButton: false, crossButtonAction: {}, mainScreen: false, containsCapsule: true, content: {
            VStack(spacing: 80){
                contentDescription
                content
                contentButtons
            }
        })
        .alert(isPresented: $vm.hasError,
        content: {
                if case .failed(let error) = vm.state {
                    return Alert(title: Text("Error"), message: Text(error.localizedDescription))
                } else {
                    return Alert(title: Text("Error"), message: Text("Something went wrong"))
            }
        })
    }
    
    private var contentDescription: some View {
        VStack{
            HStack{
                CustomImageViewResizable(inputImage: ImageConstants.Info, color: AppColors.White)
                    .frame(width: 33, height: 33)
                CustomLabel(text: Common.Information, font: AppFonts.InterRegular16, foregroundColor: AppColors.White)
            }.frame(maxWidth: 220)
        }
    }
    private var content: some View {
        VStack(spacing: 40){
            VStack{
                InputTextFieldView(text: $vm.userDetails.email, placeholder: Login.Email, keyboardType: .emailAddress, borderColor: AppColors.White, borderWidth: 3, cornerRadius: 10, sfSymbol: nil).autocorrectionDisabled(true)
                InputPasswordView(password: $vm.userDetails.password, placeholder: Login.Password, sfSymbol: nil, isSecure: $isSecure)
            }
            Divider().background(AppColors.White)
            VStack {
                InputTextFieldView(text: $vm.userDetails.firstName, placeholder: Registration.FirstName, keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 3, cornerRadius: 10, sfSymbol: nil)
                InputTextFieldView(text: $vm.userDetails.lastName, placeholder: Registration.LastName, keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 3, cornerRadius: 10, sfSymbol: nil)
                InputTextFieldView(text: $vm.userDetails.occupation, placeholder: Registration.Occupation, keyboardType: .default, borderColor: AppColors.White, borderWidth: 3, cornerRadius: 10, sfSymbol: nil)
            }
        }
    }
    private var contentButtons: some View {
        VStack{
            PrimaryButtonView(title: Login.LogIn, background: AppColors.White,foreground: AppColors.Blue,border: AppColors.White,  handler: {
                vm.register()
            })
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}


