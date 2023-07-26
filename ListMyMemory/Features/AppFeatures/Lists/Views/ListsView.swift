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
                                    taskVM.selectedBaseList = task
                                    ScreenNavigation().redirectToScreen(nextView: TaskView().environmentObject(sessionService))
                                })
                            }.onDelete(perform: self.deleteTask)
                        }.listStyle(.plain)
                            .navigationBarBackButtonHidden()
                            .navigationBarItems(trailing: EditButton())
                    } else {
                        CustomImageViewResizable(inputImage: ImageConstants.Wrong, color: AppColors.Green.opacity(0.7)).frame(width: 80, height: 80).scenePadding(.all).padding(.top, 100)
                        CustomLabelString(text: "Tasks are empty.", font: .title2.bold(), foregroundColor: AppColors.Green.opacity(0.7))
                        CustomLabelString(text: "Add new tasks by typing\na task title, and pressing\n add button.", font: .callout.bold(), foregroundColor: AppColors.Green).scenePadding(.all)
                    }
                }.onAppear{
                    taskVM.getAllLists()
                }
            }
        }
    
    var addTaskBar : some View {
            HStack {
                TextField("Add Task: ", text: self.$newTask).font(.title3).padding(12)
                SecondaryButtonView(title: "fitImage", image: ImageConstants.Add, imageColor: AppColors.White,background: AppColors.Green,height: 50, width: 50, handler: {
                    if !newTask.isEmpty {
                        self.addNewTask()
                    }
                }).padding(12)
            }.background(taskVM.baseLists.isEmpty ? AppColors.Green.opacity(0.4): Color.clear).cornerRadius(10)
            
            
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


