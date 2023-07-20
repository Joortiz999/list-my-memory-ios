//
//  ListsView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct ListsView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @StateObject private var taskVM = ListViewModelProvider(service: ListServiceProvider())
    @State var newTask : String = ""
    
    var body: some View {
            NavigationView {
                VStack {
                    addTaskBar.padding()
                    if !taskVM.baseLists.isEmpty {
                        List {
                            ForEach(taskVM.baseLists, id: \.self) { task in
                                ListRowView(task: task, handler: {
                                    ScreenNavigation().redirectToScreen(nextView: TaskView(task: task).environmentObject(sessionService))
                                })
                            }.onDelete(perform: self.deleteTask)
                        }.listStyle(.plain)
                            .navigationBarBackButtonHidden()
                            .navigationBarItems(trailing: EditButton())
                    } else {
                        CustomLabelString(text: "Tasks are empty.", font: .title.bold(), foregroundColor: AppColors.Green).scenePadding(.all).padding(.top, 100)
                        CustomLabelString(text: "Add new tasks by typing\na task title, and\npressing add button.", font: .body.bold(), foregroundColor: AppColors.Green).scenePadding(.all)
                    }
                }.onAppear{
                    taskVM.getAllLists()
                }
            }
        }
    
    var addTaskBar : some View {
            HStack {
                TextField("Add Task: ", text: self.$newTask).font(.title3)
                SecondaryButtonView(title: "fitImage", image: ImageConstants.Add, imageColor: AppColors.White,background: AppColors.Green,height: 50, width: 50, handler: {
                    if !newTask.isEmpty {
                        self.addNewTask()
                    }
                })
            }
        }
    
    func addNewTask() {
        taskVM.createList(with: newTask)
        self.newTask = ""
    }

    func deleteTask(at offsets: IndexSet) {
        let listsToDelete = offsets.map { taskVM.baseLists[$0] }
        taskVM.baseLists.remove(atOffsets: offsets)
        for list in listsToDelete {
                taskVM.deleteList(list: list)
            }
    }
}


