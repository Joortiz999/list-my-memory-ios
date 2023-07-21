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
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        BaseView(title: "", backButton: false, backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        }, crossButton: false, crossButtonAction: {}, mainScreen: false, containsCapsule: false, content: {
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
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    CustomImageViewResizable(inputImage: ImageConstants.LeftArrow, color: AppColors.White.opacity(0.8)).frame(width: 40, height: 40)
                }
                Spacer()
                CustomLabel(text: Registration.Title, font: .title3.bold(), foregroundColor: AppColors.White.opacity(0.8)).padding(.trailing, 15)
                Spacer()
            }
            HStack{
                CustomImageViewResizable(inputImage: ImageConstants.Info, color: AppColors.White)
                    .frame(width: 33, height: 33)
                CustomLabel(text: Common.Information, font: .body.bold(), foregroundColor: AppColors.White)
            }.frame(maxWidth: 220)
            CustomLabelString(text: "Introduce your login credentials and your personal information to join owr app.", font: .body.bold(), foregroundColor: AppColors.White).padding(16)
        }
    }
    private var content: some View {
        VStack(spacing: 40){
            VStack{
                CustomLabelString(text: "Login Credentials", font: .title2.bold(), foregroundColor: AppColors.White)
                InputTextFieldView(text: $vm.userDetails.email, placeholder: Login.Email, keyboardType: .emailAddress, borderColor: AppColors.White, borderWidth: 3, background: AppColors.White.opacity(0.4), cornerRadius: 10, sfSymbol: nil).autocorrectionDisabled(true)
                InputPasswordView(password: $vm.userDetails.password, placeholder: Login.Password, background: AppColors.White.opacity(0.4), isSecure: $isSecure)
            }
            Divider().background(AppColors.White)
            VStack {
                CustomLabelString(text: "Personal Information", font: .title2.bold(), foregroundColor: AppColors.White)
                InputTextFieldView(text: $vm.userDetails.firstName, placeholder: Registration.FirstName, keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 3, background: AppColors.White.opacity(0.4), cornerRadius: 10, sfSymbol: nil)
                InputTextFieldView(text: $vm.userDetails.lastName, placeholder: Registration.LastName, keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 3, background: AppColors.White.opacity(0.4), cornerRadius: 10, sfSymbol: nil)
                InputTextFieldView(text: $vm.userDetails.occupation, placeholder: Registration.Occupation, keyboardType: .default, borderColor: AppColors.White, borderWidth: 3, background: AppColors.White.opacity(0.4), cornerRadius: 10, sfSymbol: nil)
            }
        }
    }
    private var contentButtons: some View {
        VStack{
            PrimaryButtonView(title: Login.Register, background: (!vm.userDetails.email.isEmpty && !vm.userDetails.password.isEmpty && !vm.userDetails.firstName.isEmpty && !vm.userDetails.lastName.isEmpty && !vm.userDetails.occupation.isEmpty) ? AppColors.White : AppColors.White.opacity(0.5),foreground: AppColors.Blue,border: AppColors.White,  handler: {
                vm.register()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                presentationMode.wrappedValue.dismiss()
                })
            }).frame(minHeight: 50).disabled((vm.userDetails.email.isEmpty && vm.userDetails.password.isEmpty && vm.userDetails.firstName.isEmpty && vm.userDetails.lastName.isEmpty && vm.userDetails.occupation.isEmpty))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}


