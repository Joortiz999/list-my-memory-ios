//
//  AlertUtils.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation
import SwiftUI

struct ButtonData : Hashable{
    
    var buttonTitle : String
    var buttonStyle: UIAlertAction.Style
    
}

struct AlertUtils{
    
    func showAlert(title:String,message:String,buttonData:[ButtonData],complitionHandler: @escaping (String) -> Void){
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (topController.presentedViewController != nil) { topController = topController.presentedViewController! }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        for item in buttonData{
            alert.addAction(UIAlertAction(title: item.buttonTitle, style: item.buttonStyle, handler: { action in
                complitionHandler(action.title ?? "")
            }))
        }
        topController.present(alert, animated: true, completion: nil)
    }
    
}
