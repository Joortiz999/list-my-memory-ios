//
//  ModernListChildView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 22/7/23.
//

import SwiftUI

struct ModernListChildView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @StateObject var taskVM: ListViewModelProvider
    
    @State private var newChildName = ""
    @State private var newChildSection = ""
    @State private var newChildTypedIcon: String = ""
    @State private var isAddingChild = false
    
    var body: some View {
        ZStack {
            AppColors.White.ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Button(action: {
                            taskVM.performListOperation(taskVM.selectedParentList!, operationType: .update)
                            ScreenNavigation().redirectToScreen(nextView: HomeView(active: .task).environmentObject(sessionService))
                        }) {
                            CustomImageViewResizable(inputImage: ImageConstants.LeftArrow, color: AppColors.Green).frame(width: 40, height: 40)
                        }
                        Spacer()
                        Button(action: {
                            // Help Button
                            isAddingChild = true
                        }) {
                            CustomImageViewResizable(inputImage: ImageConstants.Add, color: AppColors.Green).frame(width: 40, height: 40)
                        }
                        
                        .sheet(isPresented: $isAddingChild, content: {
                            addNewChildSheet
                                .presentationDetents([.medium])
                        })
                    }.padding(16)
                    CustomLabelString(text: "\(taskVM.selectedParentList!.name)", font: .title.bold(), foregroundColor: AppColors.Green)
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
                        List {
                            ForEach(Array(taskVM.childLists.map { $0.section }.removingDuplicates()), id: \.self) { sectionName in
                                Section(header: headerView(for: sectionName)) {
                                    ForEach(taskVM.childLists.filter { $0.section == sectionName }, id: \.id) { child in
                                        ModernChildRowView(child: child, taskVM: taskVM)
                                        
                                    }
                                    .onDelete { indexSet in
                                        deleteChildren(at: indexSet, for: sectionName)
                                    }
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(AppColors.Green.opacity(0.7))
                                            .padding(.vertical, 3)
                                            .shadow(color: AppColors.Black.opacity(0.2), radius: 2)
                                    )
                                    .listRowSeparator(.hidden)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .environment(\.defaultMinListRowHeight, 50)
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            taskVM.getAllChild(taskVM.selectedParentList!)
                        }
                    }
                }
            }
        }
    }
    @ViewBuilder
    private func headerView(for sectionName: String) -> some View {
        let childrenInSection = taskVM.childLists.filter { $0.section == sectionName }
        
        if !childrenInSection.isEmpty, ModernListChild.areAllDone(children: childrenInSection) {
            HStack {
                CustomImageViewResizable(inputImage: ImageConstants.Check, color: AppColors.Green)
                    .frame(width: 25, height: 25, alignment: .center)
                Text(sectionName)
            }
        } else {
            Text(sectionName)
        }
    }
    
    private func deleteChildren(at offsets: IndexSet, for sectionName: String) {
        let childrenInSection = taskVM.childLists.filter { $0.section == sectionName }
        let sortedOffsets = offsets.sorted(by: >)
        let childrenToDelete = sortedOffsets.map { childrenInSection[$0] }
        
        // Perform any additional cleanup or deletion logic as needed
        // For example: delete them from a database or update your parent model
        for childToDelete in childrenToDelete {
            taskVM.deleteChild(childToDelete, from: taskVM.selectedParentList!)
        }
        // Refresh the child list after deletion
        taskVM.getAllChild(taskVM.selectedParentList!)
    }
    
    var addNewChildSheet: some View {
        VStack {
            Text("Add new item")
                .font(.title2.bold())
                .foregroundColor(AppColors.Orange)
                .padding()
            
            // Text fields to input child details
            Group{
                TextField("Name", text: $newChildName).bold().frame(width: 200)
                
                TextField("Section", text: $newChildSection).bold().frame(width: 200)
                HStack {
                    TextField("Emoji", text: $newChildTypedIcon).disabled(newChildTypedIcon.count >= 1)
                    Spacer()
                    if newChildTypedIcon.count >= 1 {
                        Image(systemName: "delete.left.fill")
                            .foregroundColor(AppColors.Orange)
                            .onTapGesture {
                                newChildTypedIcon = ""
                            }
                    }
                }.frame(width: 200)
            }.padding()
            // Buttons to add or cancel adding a new child
            HStack {
                SecondaryButtonView(title: Buttons.Cancel, image: "", imageColor: AppColors.White, handler: {
                    isAddingChild = false
                    newChildName = ""
                    newChildSection = ""
                    newChildTypedIcon = ""
                })
                .padding()
                SecondaryButtonView(title: Buttons.Accept, image: "", imageColor: AppColors.White, handler: {
                    // Create a new child with the provided details and add it to your model
                    // Clear the input fields and close the sheet
                    taskVM.createChild(forParent: taskVM.selectedParentList!, with: newChildName, section: newChildSection)
                    newChildName = ""
                    newChildSection = ""
                    newChildTypedIcon = ""
                    isAddingChild = false
                    
                    taskVM.getAllChild(taskVM.selectedParentList!)
                })
                .padding()
            }
        }
        .padding()
    }
    
}

struct ModernChildRowView: View {
    @State var child: ModernListChild
    @StateObject var taskVM: ListViewModelProvider
    
    var body: some View {
        HStack{
            Button(action: {
                child.isDone.toggle()
                taskVM.updateChild(child, from: taskVM.selectedParentList!)
            }, label: {
                Image(systemName: child.isDone ? "circle.inset.filled" : "circle")
                    .foregroundColor(AppColors.White)
                    .scaleEffect(1.5)
                    .padding(.trailing, 5)
            })
            Text(child.icon ?? "")
            child.isDone ? Text(child.name).font(.headline.bold()).foregroundColor(AppColors.White).strikethrough() : Text(child.name).font(.headline.bold()).foregroundColor(AppColors.White)
            
            Spacer()
        }.padding(.vertical, 5)
    }
}
