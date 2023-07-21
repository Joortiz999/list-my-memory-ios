//
//  LoginView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI
//import Firebase

struct LoginView: View {
    
    @State private var showRegistration = false
    @State private var showForgotPassword = false
    @State private var isSecure = true
    
    @StateObject private var vm = LoginViewModelProvider(service: LoginServiceProvider())
    
    var body: some View {
        ZStack{
            BaseView(title: "", backButton: false, backButtonAction: {}, crossButton: false, crossButtonAction: {}, mainScreen: false, containsCapsule: false, content: {
                VStack(spacing: 80){
                    contentTopView
                    
                    content
                    
                    contentButtonView.ignoresSafeArea(.keyboard, edges: [.bottom])
                }
            })
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.Blue)
        
    }
    
    var contentTopView: some View {
        VStack{
            CustomImageViewResizable(inputImage: ImageConstants.Profile, color: AppColors.White).frame(width: 160,height: 160)
        }
    }
    
    var content: some View {
        
        
        VStack(spacing: 16) {
            HStack {
                CustomImageViewResizable(inputImage: ImageConstants.Ampersand, color: AppColors.White)
                    .frame(width: 55,height: 55)
                InputTextFieldView(text: $vm.credentials.email, placeholder: Login.Email, keyboardType: .emailAddress, borderColor: AppColors.White, borderWidth: 3, background: AppColors.White.opacity(0.4), cornerRadius: 10, sfSymbol: nil)
                    .font(AppFonts.NeoSansBold16)
            }
            HStack {
                CustomImageViewResizable(inputImage: ImageConstants.Key, color: AppColors.White)
                    .frame(width: 55,height: 55)
                InputPasswordView(password: $vm.credentials.password, placeholder: Login.Password, background: AppColors.White.opacity(0.4), isSecure: $isSecure)
                    .font(AppFonts.NeoSansBold16)
            }
            HStack {
                Spacer()
                Button(action: {
                    showForgotPassword.toggle()
                }, label: {
                    Text("Forgot Password?")
                        .font(AppFonts.NeoSansBold14)
                        .foregroundColor(AppColors.White)
                })
                .font(AppFonts.NeoSansBold16)
                .sheet(isPresented: $showForgotPassword) {
                    ForgotPasswordView()
                        .presentationDetents([.medium, .large])
//                        .presentationCompactAdaptation(.none)
                }
            }
            
        }
        .alert(isPresented: $vm.hasError,
               content: {
            if case .failed(let error) = vm.state {
                return Alert(title: Text("Error"), message: Text(error.localizedDescription))
            } else {
                return Alert(title: Text("Error"), message: Text("Something went wrong"))
            }
        })
    }
    
    var contentButtonView: some View {
            VStack(spacing: 16) {
                PrimaryButtonView(title: "Login", background: vm.credentials.email.isEmpty && vm.credentials.password.isEmpty ? AppColors.White.opacity(0.5) : AppColors.White, foreground: AppColors.Blue) {
                        //Add Loading
                        vm.login()
                    }.font(AppFonts.NeoSansBold16).disabled(vm.credentials.email.isEmpty && vm.credentials.password.isEmpty)
                
                PrimaryButtonView(title: "Register", background: .clear, foreground: AppColors.White, border: AppColors.White) {
                    showRegistration.toggle()
                }.font(AppFonts.NeoSansBold16)
                .sheet(isPresented: $showRegistration) {
                    RegisterView()
                }
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

