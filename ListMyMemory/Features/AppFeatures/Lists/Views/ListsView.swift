//
//  ListsView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct ListsView: View {
    @ObservedObject var taskStore = TaskDataStore()
    @State var newTask : String = ""
    
    
    var body: some View {
        
            NavigationView {
                
                VStack {
                    
                    addTaskBar.padding()
                    List {
                        
                        ForEach(self.taskStore.tasks) { task in
                            
                            Text(task.taskItem)
                        }.onDelete(perform: self.deleteTask)
                        
                    }.navigationBarTitle("Tasks").navigationBarItems(trailing: EditButton())
                    
                }
            }
        }
    
    var addTaskBar : some View {
            
            HStack {
                
                TextField("Add Task: ", text: self.$newTask)
                
                Button(action: self.addNewTask, label: {
                    Text("Add New")
                })
            }
        }
    
    func addNewTask() {
        
        taskStore.tasks.append(Task(
            
            id: String(taskStore.tasks.count + 1),
            taskItem: newTask
        ))
        
        self.newTask = ""
    }

    func deleteTask(at offsets: IndexSet) {
        taskStore.tasks.remove(atOffsets: offsets)
    }
}



struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
    }
}


