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

protocol ListService {
    func getAllParents() -> AnyPublisher<[ModernListParent], Error>
    func getAllChilds(forParent parent: ModernListParent) -> AnyPublisher<[ModernListChild], Error>
    func createParent(_ name: String, theme: ModernListParentTheme) -> AnyPublisher<Void, Error>
    func createChild(parentId: String, child: ModernListChild)  -> AnyPublisher<Void, Error>
    func updateParent(_ parent: ModernListParent) -> AnyPublisher<ModernListParent, Error>
    func updateChild(_ child: ModernListChild, parentId: String) -> AnyPublisher<ModernListChild, Error>
    func deleteParent(_ list: ModernListParent) -> AnyPublisher<Void, Error>
    func deleteChild(_ child: ModernListChild, parentId: String) -> AnyPublisher<Void, Error>
}

final class ListServiceProvider: ListService {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var cancellables = Set<AnyCancellable>()
    private lazy var listsDBPath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let listRef = Database.database()
            .reference()
            .child("users/\(uid)/tasks")
        return listRef
    }()
    
    internal func getAllParents() -> AnyPublisher<[ModernListParent], Error> {
        Deferred {
            Future<[ModernListParent], Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                listsDBPath.observeSingleEvent(of: .value) { snapshot in
                    var allParents: [ModernListParent] = []
                    
                    if let snapshotValue = snapshot.value as? [String: Any] {
                        for (parentId, parentDict) in snapshotValue {
                            // Assuming each parentDict contains necessary data for ModernListParent
                            // You may need to adjust the key names and data types based on your data structure
                            if let parentDict = parentDict as? [String: Any],
                               let themeRawValue = parentDict["theme"] as? String,
                               let theme = ModernListParentTheme(rawValue: themeRawValue),
                               let name = parentDict["name"] as? String,
                               let childDone = parentDict["childDone"] as? Double {
                                
                                let modernListParent = ModernListParent(
                                    id: parentId,
                                    child: [], // Initialize empty array, as child information will be fetched separately
                                    childDone: childDone,
                                    theme: theme,
                                    name: name
                                )
                                allParents.append(modernListParent)
                            }
                        }
                    }
                    
                    promise(.success(allParents))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    internal func getAllChilds(forParent parent: ModernListParent) -> AnyPublisher<[ModernListChild], Error> {
        Deferred {
            Future<[ModernListChild], Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                let childPath = listsDBPath.child(parent.id).child("childs")
                
                childPath.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    
                    if let snapshotValue = snapshot.value as? [String:Any] {
                        var allChilds: [ModernListChild] = []
                        for (_, childsDict) in snapshotValue {
                            guard let childJSON = childsDict as? [String: Any] else { continue }
                            
                            do {
                                let childData = try JSONSerialization.data(withJSONObject: childJSON)
                                let childs = try self.decoder.decode(ModernListChild.self, from: childData)
                                
                                allChilds.append(childs)
                                
                            } catch {
                                promise(.failure(error))
                                return
                            }
                        }
                        promise(.success(allChilds))
                    } else {
                        promise(.success([]))
                    }
                    
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    
    internal func createParent(_ name: String, theme: ModernListParentTheme) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 1: Generate a unique key for the parent list
                let ref = listsDBPath.childByAutoId()
                let parentKey = ref.key
                
                // Step 2: Create the ModernListParent object
                let parentData = ModernListParent(id: parentKey!, child: [], theme: theme, name: name)
                
                // Step 3: Convert the parent object to a dictionary
                let encoder = JSONEncoder()
                guard let parentDict = try? parentData.toDictionary(encoder: encoder) else {
                    let error = NSError(domain: "Error encoding parent data", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 4: Save the data to Firebase Realtime Database
                ref.setValue(parentDict) { (error, _) in
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
    
    internal func createChild(parentId: String, child: ModernListChild) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 1: Generate a unique key for the child
                let ref = listsDBPath.child(parentId).child("childs").childByAutoId()
                let childKey = ref.key
                
                // Step 2: Update the child's parentId and id with the generated keys
                var newChild = child
                newChild.id = childKey!
                newChild.parentId = parentId
                
                // Step 3: Convert the child object to a dictionary
                let encoder = JSONEncoder()
                guard let childDict = try? newChild.toDictionary(encoder: encoder) else {
                    let error = NSError(domain: "Error encoding child data", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 4: Save the data to Firebase Realtime Database
                ref.setValue(childDict) { (error, _) in
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

    internal func updateParent(_ parent: ModernListParent) -> AnyPublisher<ModernListParent, Error> {
        Deferred {
            Future<ModernListParent, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 1: Get the reference to the parent node in Firebase
                let parentRef = listsDBPath.child(parent.id)
                
                let allChilds = parent.child
                let doneChilds = allChilds.filter { $0.isDone == true}
                let childDonePercentage = Double(doneChilds.count) / Double(allChilds.count)
                
                // Step 3: Update the parent's childDone property
                var updatedParent = parent
                updatedParent.childDone = Double(childDonePercentage)
                
                updatedParent.child = []
                
                // Step 4: Convert the parent object to a dictionary
                let encoder = JSONEncoder()
                guard let parentDict = try? updatedParent.toDictionary(encoder: encoder) else {
                    let error = NSError(domain: "Error encoding parent data", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 5: Update the parent data in Firebase
                parentRef.updateChildValues(parentDict) { (error, _) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(updatedParent))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    
    internal func updateChild(_ child: ModernListChild, parentId: String) -> AnyPublisher<ModernListChild, Error> {
        Deferred {
            Future<ModernListChild, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 1: Get the reference to the child node in Firebase
                let childRef = listsDBPath.child(parentId).child("childs").child(child.id)
                
                // Step 2: Update the child's parentId with the provided parentId
                var updatedChild = child
                updatedChild.parentId = parentId
                
                // Step 3: Convert the updated child object to a dictionary
                let encoder = JSONEncoder()
                guard let childDict = try? updatedChild.toDictionary(encoder: encoder) else {
                    let error = NSError(domain: "Error encoding child data", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 4: Update the child data in Firebase
                childRef.updateChildValues(childDict) { (error, _) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(updatedChild))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    
    internal func deleteParent(_ parent: ModernListParent) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 1: Get the reference to the parent node in Firebase
                let parentRef = listsDBPath.child(parent.id)
                
                // Step 2: Remove the parent node from Firebase
                parentRef.removeValue { (error, _) in
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
    
    internal func deleteChild(_ child: ModernListChild, parentId: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let listsDBPath = self.listsDBPath else {
                    let error = NSError(domain: "listsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                // Step 1: Get the reference to the child node in Firebase
                let childRef = listsDBPath.child(parentId).child("childs").child(child.id)
                
                // Step 2: Remove the child node from Firebase
                childRef.removeValue { (error, _) in
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
