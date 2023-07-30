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
    
    init(id: String, child: [ModernListChild], childDone: Double = 0, theme: ModernListParentTheme = .defaultTheme, name: String) {
        self.id = id
        self.child = child
        self.childDone = childDone
        self.theme = theme
        self.name = name
    }
}

extension ModernListParent {
    static var new: ModernListParent {
        ModernListParent(id: UUID().uuidString, child: [], name: "")
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
    
    init(id: String, parentId: String, dateCreated: Date = Date(), isDone: Bool = false, section: String, name: String, icon: String? = nil) {
        self.id = id
        self.parentId = parentId
        self.dateCreated = dateCreated
        self.isDone = isDone
        self.section = section
        self.name = name
        self.icon = icon
    }
}

extension ModernListChild {
    static var new: ModernListChild {
        ModernListChild(id: UUID().uuidString, parentId: UUID().uuidString, section: "", name: "")
    }
}
