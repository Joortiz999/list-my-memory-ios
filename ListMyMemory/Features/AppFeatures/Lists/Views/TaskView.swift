//
//  TaskView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 19/7/23.
//

import SwiftUI

struct TaskView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @StateObject private var taskVM = ListViewModelProvider(service: ListServiceProvider())
    @State var task: BaseList
    @State var newTask : String = ""
    
    var body: some View {
        ZStack {
            AppColors.Black.ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Button(action: {
                            ScreenNavigation().redirectToScreen(nextView: HomeView(active: .task).environmentObject(sessionService))
                        }) {
                            CustomImageViewResizable(inputImage: ImageConstants.LeftArrow, color: AppColors.White).frame(width: 40, height: 40)
                        }
                        Spacer()
                        Button(action: {
                            // Help Button
                        }) {
                            CustomImageViewResizable(inputImage: ImageConstants.Help, color: AppColors.White).frame(width: 40, height: 40)
                        }
                        Button(action: {
                            // Share Button
                        }) {
                            CustomImageViewResizable(inputImage: ImageConstants.Notification, color: AppColors.White).frame(width: 40, height: 40)
                        }
                    }.padding(16)
                    CustomLabelString(text: "\(task.name)", font: .title.bold(), foregroundColor: AppColors.White)
                        .padding(.vertical, 16)
                }
                ZStack {
                    Group {
                        LinearGradient(
                            colors: [AppColors.White, AppColors.White, AppColors.Green],
                            startPoint: .top,
                            endPoint: .bottom
                        ).cornerRadius(20).ignoresSafeArea()
                    }
                    VStack {
                        if task.subList != nil {
                            NestedListView(items: $task.subList)
                                .padding([.vertical, .horizontal], 16)
                            addTaskBar.padding()
                        } else {
                            addTaskBar.padding()
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    var addTaskBar : some View {
            HStack {
                TextField("Add New Item: ", text: self.$newTask).font(.title3.bold())
                SecondaryButtonView(title: "fitImage", image: ImageConstants.Add, imageColor: AppColors.White,background: AppColors.Green,height: 50, width: 50, handler: {
                    if !newTask.isEmpty {
                        self.addNewSubTask(parentListId: task.id)
                    }
                })
            }
        }
    
    func addNewSubTask(parentListId: String) {
        taskVM.createList(with: newTask, parentListId: parentListId)
        var new = BaseList.new
        new.name = newTask
        task.subList?.append(new)
            self.newTask = ""
        }
}
    
    struct NestedListView: View {
        @Binding var items: [BaseList]?
        
        var body: some View {
            List(items ?? [], children: \.subList) { item in
                HStack {
                    if item.status == .done{
                        SecondaryButtonView(title: "fitImage", image: ImageConstants.Check, imageColor: AppColors.White,background: AppColors.Green,height: 40, width: 40, handler: {
                            
                        })
                    } else {
                        SecondaryButtonView(title: "fitImage", image: ImageConstants.Refresh, imageColor: AppColors.White, background: AppColors.Yellow,height: 40, width: 40, handler: {
                            
                        })
                    }
                    if item.status == .done {
                        Text(item.name)
                            .font(.system(.title3, design: .rounded))
                            .bold()
                            .strikethrough()
                    } else {
                        Text(item.name)
                            .font(.system(.title3, design: .rounded))
                            .bold()
                            
                    }
                    Spacer()
                    Button(action: {
                        // This will Show a pupUp for adding a name and create sub List Further
                    }, label: {
                        CustomImageViewResizable(inputImage: ImageConstants.Add, color: AppColors.Blue)
                            .frame(width: 30, height: 30).scaledToFit()
                    })
                    Button(action: {
                        // This will Show a pupUp for adding a name and create sub List Further
                    }, label: {
                        CustomImageViewResizable(inputImage: ImageConstants.Trash, color: AppColors.Red)
                            .frame(width: 30, height: 30).scaledToFit()
                    })
                }
            }.listStyle(.plain)
        }
        
//        func addNewSubTask(parentListId: String) {
//                taskVM.createList(with: newTask, parentListId: parentListId)
//                self.newTask = ""
//            }
    }
