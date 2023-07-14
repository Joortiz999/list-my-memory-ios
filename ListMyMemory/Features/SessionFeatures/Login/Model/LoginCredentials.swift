//
//  LoginCredentials.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}
extension LoginCredentials {
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
