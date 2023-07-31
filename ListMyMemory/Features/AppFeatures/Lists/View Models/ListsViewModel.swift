//
//  ListsViewModel.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 19/7/23.
//

import Foundation
import Combine

enum ListOperationType {
    case update
    case redo
    case delete
}

protocol ListViewModel {
    var service: ListService { get }
    var newParent: ModernListParent { get set }
    var newChild: ModernListChild { get set }
    var parentLists: [ModernListParent] { get set }
    var childLists: [ModernListChild] { get set }
    
    init(service: ListService)
    
    func getAllParents()
    func getAllChild(_ parent: ModernListParent)
    func createParent(with name: String)
    func createChild(forParent parent: ModernListParent, with name: String, section: String)
    func performListOperation(_ list: ModernListParent, operationType: ListOperationType)
    func updateChild(_ child: ModernListChild, from parent: ModernListParent)
    func redoChilds(_ child: [ModernListChild], from parent: ModernListParent)
    func deleteChild(_ child: ModernListChild, from parent: ModernListParent)
}

final class ListViewModelProvider: ObservableObject, ListViewModel {
    
    @Published var newParent: ModernListParent = ModernListParent.new
    @Published var newChild: ModernListChild = ModernListChild.new
    @Published var parentLists: [ModernListParent] = []
    @Published var childLists: [ModernListChild] = []
    @Published var selectedParentList: ModernListParent?
    
    let service: ListService
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: ListService) {
        self.service = service
    }
    
    func getAllParents() {
        service.getAllParents()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                self?.parentLists = data.sorted(by: {$0.childDone > $1.childDone})
                // Perform any additional UI updates or completion handling here
            })
            .store(in: &subscriptions)
    }
    
    func getAllChild(_ parent: ModernListParent) {
        service.getAllChilds(forParent: parent)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.childLists = data.sorted(by: {$0.dateCreated > $1.dateCreated})
            })
            .store(in: &subscriptions)
    }
    
    func createParent(with name: String) {
        service.createParent(name, theme: .defaultTheme)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to create list: \(error)")
                    // Handle error, show alert, etc.
                case .finished:
                    print("List creation finished successfully.")
                }
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)
    }
    
    func createChild(forParent parent: ModernListParent, with name: String, section: String) {
        let newChild = ModernListChild(id: UUID().uuidString, parentId: parent.id, section: section, name: name)
        service.createChild(parentId: parent.id, child: newChild)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to create child list: \(error)")
                    // Handle error, show alert, etc.
                case .finished:
                    print("Child list creation finished successfully.")
                }
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)
    }
    
    // Combine the update and delete operations into a single function.
    func performListOperation(_ list: ModernListParent, operationType: ListOperationType) {
        switch operationType {
        case .update:
            
            var updateParent = list
            updateParent.child = childLists
            
            service.updateParent(updateParent)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Failed to update list: \(error)")
                        // Handle error, show alert, etc.
                    case .finished:
                        print("List updated successfully.")
                    }
                }, receiveValue: { _ in
                })
                .store(in: &subscriptions)
        case .delete:
            service.deleteParent(list)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Failed to delete list: \(error)")
                        // Handle error, show alert, etc.
                    case .finished:
                        print("List deleted successfully.")
                    }
                }, receiveValue: { _ in
                })
                .store(in: &subscriptions)
        case .redo:
            break
        }
    }
    
    // Function to update a child list
    func updateChild(_ child: ModernListChild, from parent: ModernListParent) {
        service.updateChild(child, parentId: parent.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to update child list: \(error)")
                    // Handle error, show alert, etc.
                case .finished:
                    self.getAllChild(self.selectedParentList!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.performListOperation(self.selectedParentList!, operationType: .update)
                    })
                    
                }
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)
    }
    func redoChilds(_ childs: [ModernListChild], from parent: ModernListParent) {
        service.redoChilds(childs, parentId: parent.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to update child list: \(error)")
                    // Handle error, show alert, etc.
                case .finished:
                    self.getAllChild(self.selectedParentList!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.performListOperation(self.selectedParentList!, operationType: .update)
                    })
                    
                }
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)
    }
    
    // Function to delete a child list
    func deleteChild(_ child: ModernListChild, from parent: ModernListParent) {
        service.deleteChild(child, parentId: parent.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to delete child list: \(error)")
                    // Handle error, show alert, etc.
                case .finished:
                    print("Child list deleted successfully.")
                }
            }, receiveValue: { _ in
            })
            .store(in: &subscriptions)
    }
}
