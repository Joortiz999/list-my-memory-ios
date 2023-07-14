//
//  ForgotPasswordViewModel.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import Foundation
import Combine

protocol ForgotPasswordViewModel {
    var service: ForgotPasswordService { get }
    var email: String { get }
    init(service: ForgotPasswordService)
    func sendPasswordReset()
}

final class ForgotPasswordViewModelProvider: ObservableObject, ForgotPasswordViewModel {
    let service: ForgotPasswordService
    @Published var email: String = ""
    private var subscriptions = Set<AnyCancellable>()
    init(service: ForgotPasswordService) {
        self.service = service
    }
    
    func sendPasswordReset() {
        service.sendForgotPassword(to: email)
            .sink { res in
                switch res {
                case .failure(let err):
                    print("Failed: \(err)")
                default: break
                }
            } receiveValue: {
                print("Sent Password Reset Request")
            }
            .store(in: &subscriptions)
    }
}
