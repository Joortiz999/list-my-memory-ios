//
//  ListsService.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 19/7/23.
//

import Foundation
import Combine
import Firebase
import FirebaseDatabase

enum ListKeys: String {
    case id
    case status
    case name
    case icon
    case dateCreated
    case subList
}

protocol ListService {
    func getAllLists() -> AnyPublisher<[BaseList], Error>
    func createList(_ name: String, parentListId: String?) -> AnyPublisher<Void, Error>
    func updateList(_ list: BaseList) -> AnyPublisher<BaseList, Error>
    func deleteList(_ list: BaseList) -> AnyPublisher<Void, Error>
}

final class ListServiceProvider: ListService {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private lazy var listsDBPath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let listRef = Database.database()
            .reference()
            .child("users/\(uid)/tasks")
        return listRef
    }()
    
    internal func getAllLists() -> AnyPublisher<[BaseList], Error> {
        Deferred {
            Future<[BaseList], Error> { promise in
                guard let listDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                listDBPath.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    
                    var allLists: [BaseList] = []
                    
                    if let snapshotValue = snapshot.value as? [String: Any] {
                        // Helper function to recursively traverse nested lists
                        func populateLists(_ listDict: [String: Any]) -> BaseList? {
                            guard
                                let id = listDict["id"] as? String,
                                let statusRawValue = listDict["status"] as? String,
                                let status = ListStatus(rawValue: statusRawValue),
                                let name = listDict["name"] as? String,
                                let dateDouble = listDict["dateCreated"] as? Double
                                    
                                else {
                                return nil
                            }
                            
                            var baseList = BaseList(
                                id: id,
                                status: status,
                                name: name,
                                icon: listDict["icon"] as? String,
                                dateCreated: Date(timeIntervalSince1970: dateDouble),
                                subList: nil
                            )
                            
                            if let subListArray = listDict["subList"] as? [[String: Any]] {
                                baseList.subList = subListArray.compactMap(populateLists)
                            }
                            
                            return baseList
                        }
                        
                        for (_, listDict) in snapshotValue {
                            guard let listDict = listDict as? [String: Any] else {
                                continue
                            }
                            
                            if let baseList = populateLists(listDict) {
                                allLists.append(baseList)
                            }
                        }
                    }
                    
                    promise(.success(allLists))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    internal func createList(_ name: String, parentListId: String?) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }

                var newList = BaseList(
                    id: UUID().uuidString,
                    status: .inprogress,
                    name: name,
                    dateCreated: Date(),
                    subList: nil
                )

                if let parentListId = parentListId {
                    // Fetch the parent list from the database
                    let parentListRef = listsDBPath.child(parentListId)
                    parentListRef.observeSingleEvent(of: .value) { snapshot in
                        if let parentListJSON = snapshot.value as? [String: Any],
                           let parentListData = try? JSONSerialization.data(withJSONObject: parentListJSON),
                           var parentList = try? JSONDecoder().decode(BaseList.self, from: parentListData) {

                            // Add the new subtask to the parent list
                            parentList.addSubtask(name)

                            // Convert the updated parent list back to JSON
                            let encoder = JSONEncoder()
                            if let updatedParentListData = try? encoder.encode(parentList),
                               let updatedParentListJSON = try? JSONSerialization.jsonObject(with: updatedParentListData, options: []) as? [String: Any] {

                                // Save the updated parent list back to the database
                                parentListRef.setValue(updatedParentListJSON) { error, _ in
                                    if let error = error {
                                        promise(.failure(error))
                                    } else {
                                        promise(.success(()))
                                    }
                                }
                            } else {
                                promise(.failure(NSError(domain: "Failed to convert parent list to JSON", code: 0, userInfo: nil)))
                            }
                        } else {
                            promise(.failure(NSError(domain: "Failed to fetch parent list or decode it", code: 0, userInfo: nil)))
                        }
                    }
                } else {
                    // No parent list specified, create a new top-level list
                    do {
                        let encoder = JSONEncoder()
                        let newListData = try encoder.encode(newList)
                        let newListJSON = try JSONSerialization.jsonObject(with: newListData, options: []) as? [String: Any]

                        if let newListJSON = newListJSON {
                            listsDBPath.child(newList.id).setValue(newListJSON) { error, _ in
                                if let error = error {
                                    promise(.failure(error))
                                } else {
                                    promise(.success(()))
                                }
                            }
                        }
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    
    internal func updateList(_ list: BaseList) -> AnyPublisher<BaseList, Error> {
        Deferred {
            Future<BaseList, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }

                // Helper function to recursively update nested lists
                func updateNestedLists(_ list: BaseList) -> [String: Any] {
                    var listDict: [String: Any] = [
                        "id": list.id,
                        "status": list.status.rawValue,
                        "name": list.name,
                        "dateCreated": DateFormatter.listDateFormatter.string(from: list.dateCreated)
                    ]

                    if let icon = list.icon {
                        listDict["icon"] = icon
                    }

                    if let subList = list.subList {
                        var subListDict: [String: Any] = [:]
                        for subListEntry in subList {
                            let subListData = updateNestedLists(subListEntry)
                            subListDict[subListEntry.id] = subListData
                        }
                        listDict["subList"] = subListDict
                    }

                    return listDict
                }

                let updatedListData = updateNestedLists(list)

                listsDBPath.child(list.id).setValue(updatedListData) { error, _ in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(list))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    internal func deleteList(_ list: BaseList) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }

                // Helper function to recursively delete nested lists
                func deleteNestedLists(_ list: BaseList) {
                    if let subList = list.subList {
                        for subListEntry in subList {
                            deleteNestedLists(subListEntry)
                            listsDBPath.child(subListEntry.id).removeValue() // Remove the nested list from the database
                        }
                    }
                }

                deleteNestedLists(list)

                listsDBPath.child(list.id).removeValue { error, _ in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
}
