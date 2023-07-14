//
//  SettingsView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            
            Form {
                
                Section(header: Text("Display"), footer: Text("System setting description")) {
                    // TODO: Handdle Toggles and apply changes
                    Toggle(isOn: .constant(false), label: {
                        Text("Dark Mode")
                    })
                    
                    Toggle(isOn: .constant(true), label: {
                        Text("Use system settings")
                    })
                    
                }
                Section {
                    Label("Follow me on social media", systemImage: "link")
                }
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .semibold))
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
