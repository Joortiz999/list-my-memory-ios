//
//  ModernList.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 22/7/23.
//

import Foundation

enum ModernListParentTheme: String, Codable {
    case defaultTheme
    case marketTheme
}

struct ModernListParent: Identifiable, Hashable, Codable {
    var id: String
    var child: [ModernListChild]
    var childDone: Double
    var theme: ModernListParentTheme
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case child
        case childDone
        case theme
        case name
    }
    
    init(child: [ModernListChild], childDone: Double, theme: ModernListParentTheme = .defaultTheme, name: String) {
        self.id = UUID().uuidString
        self.child = child
        self.childDone = childDone
        self.theme = theme
        self.name = name
    }
}

extension ModernListParent {
    static func exampleParentList() -> [ModernListParent] {
        return [
            ModernListParent(child: ModernListChild.exampleChildList(parentID: "1"), childDone: 0/100, name: "Cleaning"),
            ModernListParent(child: ModernListChild.exampleChildList(parentID: "1"), childDone: 25/100, name: "Market"),
            ModernListParent(child: ModernListChild.exampleChildList(parentID: "1"), childDone: 50/100,theme: .marketTheme, name: "Drinks"),
            ModernListParent(child: ModernListChild.exampleChildList(parentID: "1"), childDone: 75/100,theme: .marketTheme, name: "Trip"),
            ModernListParent(child: ModernListChild.exampleChildList(parentID: "1"), childDone: 100/100,theme: .marketTheme, name: "Buisness")]
    }
    
    
}

struct ModernListChild: Identifiable, Hashable, Codable {
    var id: String
    var parentId: String
    var dateCreated = Date()
    var isDone: Bool
    var section: String
    var name: String
    var icon: String?
    
    static func areAllDone(children: [ModernListChild]) -> Bool {
            return children.allSatisfy { $0.isDone }
        }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case parentId
        case dateCreated
        case isDone
        case section
        case name
        case icon
    }
    
    init(parentId: ModernListParent.ID, dateCreated: Date = Date(), isDone: Bool = false, section: String, name: String, icon: String? = nil) {
        self.id = UUID().uuidString
        self.parentId = parentId
        self.dateCreated = dateCreated
        self.isDone = isDone
        self.section = section
        self.name = name
        self.icon = icon
    }
}

extension ModernListChild {
    static func exampleChildList(parentID: String) -> [ModernListChild] {
        return [
            ModernListChild(parentId: parentID, section: "Fruits", name: "Apple", icon: "🍎"),
            ModernListChild(parentId: parentID, section: "Fruits", name: "Banana", icon: "🍌"),
            ModernListChild(parentId: parentID, isDone: true, section: "Fruits", name: "Mango", icon: "🥭"),
            ModernListChild(parentId: parentID, isDone: true, section: "Breads", name: "Stale Baguette", icon: "🥖"),
            ModernListChild(parentId: parentID, section: "Meats", name: "Chicken", icon: "🍗"),
            ModernListChild(parentId: parentID, section: "Meats", name: "Bacon", icon: "🥓")]
    }
}
