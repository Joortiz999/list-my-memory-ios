//
//  RegistrationViewModel.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import Foundation
import Combine

enum RegistrationState {
    case successfull
    case failed(error: Error)
    case na
}

protocol RegistrationViewModel {
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var hasError: Bool { get }
    var userDetails: RegistrationDetails { get }
    init(service: RegistrationService)
    func register()
}

final class RegistrationViewModelProvider: RegistrationViewModel, ObservableObject {
    
    let service: RegistrationService
    
    @Published var state: RegistrationState = .na
    @Published var hasError: Bool = false
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
        setuperrorSubsription()
    }
    func register() {
        service.register(with: userDetails)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
}
private extension RegistrationViewModelProvider {
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
