//
//  ModernListParentView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 22/7/23.
//

import SwiftUI


struct ModernParentRowView: View {
    typealias ActionHandler = () -> Void
    
    let parent: ModernListParent
    var handler : ActionHandler
    
    init(parent: ModernListParent, handler: @escaping ModernParentRowView.ActionHandler) {
        self.parent = parent
        self.handler = handler
    }
    var body: some View {
        Button(action: handler, label: {
            HStack{
                if parent.childDone != 1 {
                    CircularProgressView(progress: parent.childDone)
                        .frame(maxWidth: 40, maxHeight: 40)
                        .padding(5)
                } else {
                    CustomImageViewResizable(inputImage: ImageConstants.Check, color: AppColors.White).frame(width: 50, height: 50)
                        .overlay{
                            Circle()
                                .trim(from: 0.12, to: 0.88)
                                .stroke(
                                    AppColors.White,
                                    style: StrokeStyle(
                                        lineWidth: 5,
                                        lineCap: .round
                                    )
                                )
                        }
                }
                Divider()
                    .frame(width: 3, height: 60)
                    .overlay(AppColors.White)
                Text(parent.name).font(.title2.bold()).foregroundColor(AppColors.White)
                Spacer()
                CustomImageViewResizable(inputImage: ImageConstants.RightArrow, color: AppColors.White).frame(width: 40, height: 40)
            }
        })
    }
}

struct ModernListParentView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @StateObject var taskVM: ListViewModelProvider
    @State var newTask : String = ""
    var body: some View {
        NavigationView {
            VStack{
                addTaskBar.padding()
                    .onAppear{
                        taskVM.getAllParents()
                    }
                if !taskVM.parentLists.isEmpty {
                    List{
                        if !taskVM.parentLists.filter({$0.childDone != 1}).isEmpty {
                            Section {
                                ForEach(taskVM.parentLists.filter{$0.childDone != 1}) { list in
                                    
                                    ModernParentRowView(parent: list) {
                                        taskVM.selectedParentList = list
                                        ScreenNavigation().redirectToScreen(nextView: ModernListChildView(taskVM: taskVM).environmentObject(sessionService))
                                    }
                                    .listRowSeparator(.hidden)
                                    
                                }
                                .onDelete(perform: self.deleteTask)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(AppColors.Green.opacity(0.7))
                                        .padding(.vertical, 3)
                                )
                            } header: {
                                Text("In Progress").font(.headline.bold()).foregroundColor(AppColors.Gray)
                            }
                        }
                        if !taskVM.parentLists.filter({$0.childDone == 1}).isEmpty {
                            Section {
                                ForEach(taskVM.parentLists.filter{$0.childDone == 1}) { list in
                                    ModernParentRowView(parent: list) {
                                        taskVM.selectedParentList = list
                                        ScreenNavigation().redirectToScreen(nextView: ModernListChildView(taskVM: taskVM).environmentObject(sessionService))
                                    }
                                    .listRowSeparator(.hidden)
                                }
//                                .onDelete(perform: self.hideTask)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(AppColors.Green.opacity(0.7))
                                        .padding(.vertical, 3)
                                )
                                
                            }  header: {
                                Text("Done").font(.headline.bold())
                            }
                        }
                    }.listRowSeparator(.hidden)
                } else {
                    Text("No task found")
                }
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
            }.background(taskVM.parentLists.isEmpty ? AppColors.Green.opacity(0.4): Color.clear).cornerRadius(10)
            
            
        }
    
    func addNewTask() {
        taskVM.createParent(with: newTask)
        self.newTask = ""
        taskVM.getAllParents()
    }

    func deleteTask(at offsets: IndexSet) {
        let listsToDelete = offsets.map { taskVM.parentLists[$0] }
        taskVM.parentLists.remove(atOffsets: offsets)
        for list in listsToDelete {
            taskVM.performListOperation(list, operationType: .delete)
            }
        taskVM.getAllParents()
    }
    
}
