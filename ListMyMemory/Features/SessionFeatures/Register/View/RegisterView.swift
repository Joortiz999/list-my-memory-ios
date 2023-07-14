//
//  RegisterView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var vm = RegistrationViewModelProvider(service: RegistrationServiceProvider())
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    InputTextFieldView(text: $vm.userDetails.email, placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                    
                    InputPasswordView(password: $vm.userDetails.password, placeholder: "Password", sfSymbol: "lock")
                    
                    Divider()
                    
                    InputTextFieldView(text: $vm.userDetails.firstName, placeholder: "First Name", keyboardType: .namePhonePad, sfSymbol: nil)
                    
                    InputTextFieldView(text: $vm.userDetails.lastName, placeholder: "Last Name", keyboardType: .namePhonePad, sfSymbol: nil)
                    
                    InputTextFieldView(text: $vm.userDetails.occupation, placeholder: "Occupation", keyboardType: .namePhonePad, sfSymbol: nil)
                }
                
                PrimaryButtonView(title: "Sign Up") {
                    vm.register()
                }
            }
            .padding(.horizontal, 15)
            .navigationTitle("LYM Registration")
            .applyClose()
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
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
