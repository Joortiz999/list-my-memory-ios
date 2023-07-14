//
//  ForgotPasswordService.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import Foundation
import Combine
import FirebaseAuth

protocol ForgotPasswordService {
    func sendForgotPassword(to email: String) -> AnyPublisher<Void, Error>
}

final class ForgotPasswordServiceProvider: ForgotPasswordService {
    func sendForgotPassword(to email: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
