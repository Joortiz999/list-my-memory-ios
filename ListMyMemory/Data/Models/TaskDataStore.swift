//
//  TaskDataStore.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 5/4/23.
//

import Foundation
import SwiftUI
import Combine

struct Task : Identifiable {
    var id = String()
    var taskItem = String()
}

class TaskDataStore: ObservableObject {
    static let shared = TaskDataStore()
    @Published var tasks = [Task]()
    @Published var exampleTasks = [Task(id: "1",taskItem: "Market"),
                                   Task(id: "2",taskItem: "Groceries"),]
}
