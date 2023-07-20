//
//  ListModel.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 19/7/23.
//

import Foundation

enum ListStatus: String, Codable {
    case done
    case inprogress
}

struct BaseList: Identifiable, Codable, Hashable {
    var id: String
    var status: ListStatus
    var name: String
    var icon: String?
    var dateCreated: Date
    var subList: [BaseList]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case name
        case icon
        case dateCreated
        case subList
    }
    
    init(id: String, status: ListStatus, name: String, icon: String? = nil, dateCreated: Date, subList: [BaseList]? = nil) {
        self.id = id
        self.status = status
        self.name = name
        self.icon = icon
        self.dateCreated = dateCreated
        self.subList = subList
    }
    
    mutating func addSubtask(_ name: String) {
            var newSubtask = BaseList(
                id: UUID().uuidString,
                status: .inprogress,
                name: name,
                dateCreated: Date(),
                subList: nil
            )

            if subList == nil {
                subList = [newSubtask]
            } else {
                subList?.append(newSubtask)
            }
        }
}

extension BaseList {
    static var new: BaseList {
        BaseList(id: UUID().uuidString, status: .inprogress, name: "", icon: nil, dateCreated: Date(), subList: nil)
    }
}
