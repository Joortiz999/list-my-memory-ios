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
    
    @StateObject private var vm = LoginViewModelProvider(service: LoginServiceProvider())
    
    var body: some View {
        
        content
    }
    
    var content: some View {
        
        VStack(spacing: 16) {
            
            VStack(spacing: 16) {
                
                InputTextFieldView(text: $vm.credentials.email, placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                
                InputPasswordView(password: $vm.credentials.password, placeholder: "Password", sfSymbol: "lock")
                
            }
            HStack {
                Spacer()
                Button(action: {
                    showForgotPassword.toggle()
                }, label: {
                    Text("Forgot Password?")
                })
                .font(.system(size: 16, weight: .bold))
                .sheet(isPresented: $showForgotPassword) {
                    ForgotPasswordView()
                }
            }
            
            VStack(spacing: 16) {
                PrimaryButtonView(title: "Login") {
                    vm.login()
                }
                
                PrimaryButtonView(title: "Register", background: .clear, foreground: .blue, border: .blue) {
                    showRegistration.toggle()
                }
                .sheet(isPresented: $showRegistration) {
                    RegisterView()
                }
            }
        }
        .padding(.horizontal, 15)
        .navigationTitle("Lym Login")
        .alert(isPresented: $vm.hasError,
        content: {
                if case .failed(let error) = vm.state {
                    return Alert(title: Text("Error"), message: Text(error.localizedDescription))
                } else {
                    return Alert(title: Text("Error"), message: Text("Something went wrong"))
            }
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}

