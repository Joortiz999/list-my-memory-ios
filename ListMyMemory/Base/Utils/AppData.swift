//
//  AppData.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation
import SwiftUI

class AppData: ObservableObject {
    static let shared = AppData()
    var userFirstName = ""
    var userLastName = ""
    var sessionIsActive = false
    
    func clearAppData(){
        self.userFirstName = ""
        self.userLastName = ""
        self.sessionIsActive = false
    }
}

struct AppUserDefaults{
    static let isFaceIdRegistered = "FaceIdRegistered"
    func setValueForKey(value:Any,key:String){
        let defaults = UserDefaults()
        defaults.set(value, forKey: key)
    }
    
    func getValueForKey(key:String) -> Any?{
        let defaults = UserDefaults()
        return defaults.value(forKey: key)
    }
}

extension Bundle {
    public var appName: String           { getInfo("CFBundleName")  }
    public var displayName: String       { getInfo("CFBundleDisplayName")}
    public var language: String          { getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String        { getInfo("CFBundleIdentifier")}
    public var appBuild: String          { getInfo("CFBundleVersion") }
    public var appVersionLong: String    { getInfo("CFBundleShortVersionString") }
    public var appVersionShort: String   { getInfo("CFBundleShortVersion") }
    //    public var copyright: String         { getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}
