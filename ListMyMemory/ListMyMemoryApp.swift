//
//  ListMyMemoryApp.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI
import Firebase

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ListMyMemoryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var sessionService = SessionServiceProvider()
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch sessionService.state {
                case .loggedIn:
                    EventsView().environmentObject(sessionService)
                case .loggedOut:
                    LoginView()
                }
            }
        }
    }
}
