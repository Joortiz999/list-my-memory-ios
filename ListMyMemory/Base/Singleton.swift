//
//  Singleton.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation
class Singleton {
    var currentLanguage : String?
    static let sharedInstance = Singleton()
    
    func languageSelect(key : String) -> String{
        var path : String?
        if(Singleton.sharedInstance.currentLanguage == "es-MX"){
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }else{
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }
        let bundle : Bundle = Bundle.init(path: path!)!
        return bundle.localizedString(forKey: key, value: "", table: "Localizable")
    }
    func languagePath() -> String{
        var path : String?
        if(Singleton.sharedInstance.currentLanguage == "es-MX"){
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }else if(Singleton.sharedInstance.currentLanguage == "en"){
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }else{
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }
        return path!
    }
}
