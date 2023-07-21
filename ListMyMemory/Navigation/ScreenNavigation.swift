//
//  ScreenNavigation.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import SwiftUI

struct ScreenNames{
    //MARK: - General Screens
    static let SplashScreen = "SplashScreen"
    static let SettingsScreem = "SettingsScreen"
    static let homeScreen = "HomeScreen"
    
    //MARK: - Pre-Login Screens
    static let LoginScreen = "LoginScreen"
    static let RegistrationScreen = "RegistrationScreen"
    static let ForgotPasswordScreen = "ForgotPasswordScreen"
    
    //MARK: - Event Screens
    static let EventsScreen = "EventsScreen"
    static let CreateEventScreen = "CreateEventScreen"
    static let EventDetailScreen = "EventDetailScreen"
    static let EventSuggestionScreen = "EventSuggestionScreen"
    
    //MARK: - List Screens
    static let ListScreen = "ListScreen"
    static let AddListScreen = "AddListScreen"
    
}

struct ScreenNavigation<Content> where Content : View{
    var screenName : String? = ""
    func redirectToScreen(nextView: Content) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            
            if screenName == ScreenNames.SplashScreen || screenName == ScreenNames.SettingsScreem || screenName == ScreenNames.LoginScreen || screenName == ScreenNames.RegistrationScreen || screenName == ScreenNames.SplashScreen || screenName == ScreenNames.ForgotPasswordScreen || screenName == ScreenNames.EventsScreen || screenName == ScreenNames.CreateEventScreen || screenName == ScreenNames.EventDetailScreen || screenName == ScreenNames.ListScreen || screenName == ScreenNames.AddListScreen{
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let window = windowScene.windows.first
                        window?.rootViewController = HostingController(rootView: nextView)
                        window?.makeKeyAndVisible()
                    }
                }
            }else{
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        let window = windowScene.windows.first
                        window?.rootViewController = UIHostingController(rootView: nextView)
                        window?.makeKeyAndVisible()
                    }
                }
            }
        })
    }
    
}

class HostingController<ContentView>: UIHostingController<ContentView> where ContentView : View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
