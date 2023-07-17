//
//  ListsView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct ListsView: View {
    @ObservedObject var taskStore = TaskDataStore.shared
    @State var newTask : String = ""
    @State var index: Int?
    
    
    var body: some View {
            NavigationView {
                VStack {
                    addTaskBar.padding()
                    List {
                        ForEach(self.taskStore.exampleTasks) { task in
                            ListRowView(task: task, roundedTop: false, roundedBottom: false, handler: {
                                
                            })
                            
                        }.onDelete(perform: self.deleteTask)
                    }.listStyle(.plain)
                    
                    .navigationBarBackButtonHidden()
                    .navigationBarItems(trailing: EditButton())
                }
            }
        }
    
    var addTaskBar : some View {
            HStack {
                
                TextField("Add Task: ", text: self.$newTask).font(.title3)
                
                SecondaryButtonView(title: "fitImage", image: ImageConstants.Add, imageColor: AppColors.White,background: AppColors.Green,height: 50, width: 50, handler: {
                    self.addNewTask()
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


