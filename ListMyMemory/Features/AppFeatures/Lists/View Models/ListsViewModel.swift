//
//  ListsViewModel.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 19/7/23.
//

import Foundation
import Combine

protocol ListViewModel {
    var service: ListService { get }
    var newList: BaseList { get set }
    var baseLists: [BaseList] { get set }
    
    init(service: ListService)
    
    func getAllLists()
    func createList(with name: String, parentListId: String?)
    func updateList(list: BaseList)
    func deleteList(list: BaseList)
}

final class ListViewModelProvider: ObservableObject, ListViewModel {
    
    let service: ListService
    @Published var newList: BaseList = BaseList.new
    @Published var baseLists: [BaseList] = []
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: ListService) {
        self.service = service
    }
    
    func getAllLists() {
        service.getAllLists()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                self?.baseLists = data
                // Perform any additional UI updates or completion handling here
            })
            .store(in: &subscriptions)
    }
    
    func createList(with name: String, parentListId: String? = nil) {
            service.createList(name, parentListId: parentListId)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Failed to create list: \(error)")
                        // Handle error, show alert, etc.
                    case .finished:
                        print("List creation finished successfully.")
                        // Handle successful completion if needed.
                        self.getAllLists()
                    }
                }, receiveValue: { _ in
                    // The receiveValue will not be called in this case, as the createList function returns Void.
                })
                .store(in: &subscriptions)
        }
    
    func updateList(list: BaseList) {
        service.updateList(list)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to update list: \(error)")
                    // Handle error, show alert, etc.
                case .finished:
                    print("List updated successfully.")
                    // Handle successful completion if needed.
                    self.getAllLists()
                }
            }, receiveValue: { _ in
                // The receiveValue will not be called in this case, as the updateList function returns BaseList.
            })
            .store(in: &subscriptions)
    }

    
    func deleteList(list: BaseList) {
        service.deleteList(list)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to delete list: \(error)")
                    // Handle error, show alert, etc.
                case .finished:
                    print("List deleted successfully.")
                    // Handle successful completion if needed.
                    self.getAllLists()
                }
            }, receiveValue: { _ in
                // The receiveValue will not be called in this case, as the deleteList function returns Void.
            })
            .store(in: &subscriptions)
    }

    
    
}
