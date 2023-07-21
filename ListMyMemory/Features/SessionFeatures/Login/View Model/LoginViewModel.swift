//
//  LoginViewModel.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import Foundation
import Combine

enum LoginState {
    case successfull
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    var service: LoginService { get }
    var state: LoginState { get }
    var credentials: LoginCredentials { get }
    var hasError: Bool { get }
    init(service: LoginService)
    func login()
}

final class LoginViewModelProvider: LoginViewModel, ObservableObject {
    let service: LoginService
    @Published var hasError: Bool = false
    @Published var state: LoginState  = .na
    @Published var credentials: LoginCredentials = LoginCredentials.new
    @Published var usernamePlaceholder = Login.Email
    @Published var passwordPlaceholder = "Password"
    @Published var isUserNameEditing: Bool = false
    @Published var isPasswordEditing: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: LoginService) {
        self.service = service
        setuperrorSubsription()
    }
    
    func login() {
        service.login(with: credentials)
            .sink { res in
                switch res {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
}

private extension LoginViewModelProvider {
    func setuperrorSubsription() {
        $state.map {
            state -> Bool in
            switch state {
            case .successfull, .na:
                return false
            case .failed:
                return true
            }
        }
        .assign(to: &$hasError)
    }
}
