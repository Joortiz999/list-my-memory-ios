//
//  ModernListChildView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 22/7/23.
//

import SwiftUI

struct ModernListChildView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @State var parent: ModernListParent
    @State private var groupedParentChild: [String: [ModernListChild]] = [:]
    
    @State private var newChildName = ""
    @State private var newChildSection = ""
    @State private var newChildTypedIcon: String = ""
    
    @State private var isAddingChild = false
    
    init(parent: ModernListParent) {
        self.parent = parent
    }
    
    var body: some View {
        ZStack {
            AppColors.White.ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Button(action: {
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
                    CustomLabelString(text: "\(parent.name)", font: .title.bold(), foregroundColor: AppColors.Green)
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
                            ForEach(Array(groupedParentChild.keys.sorted()), id: \.self) { sectionName in
                                Section(header: headerView(for: sectionName)) {
                                    ForEach(groupedParentChild[sectionName]!, id: \.id) { child in
                                        ModernChildRowView(child: child)
                                    }
                                    .onDelete { indexSet in
                                        deleteChildren(at: indexSet, for: sectionName)
                                    }
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(AppColors.Green.opacity(0.7))
                                            .padding(.vertical, 3)
                                            .shadow(color: AppColors.Black.opacity(0.2),radius: 2)
                                            
                                    )
                                    .listRowSeparator(.hidden)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .environment(\.defaultMinListRowHeight, 50)
                        
                    }
                    .onAppear {
                        groupedParentChild = Dictionary(grouping: parent.child, by: { $0.section })
                    }
                }
            }
        }
    }
    @ViewBuilder
    private func headerView(for sectionName: String) -> some View {
        if let children = groupedParentChild[sectionName], ModernListChild.areAllDone(children: children) {
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
            if let sectionChildren = groupedParentChild[sectionName] {
                // Remove items from the model
                let childrenToDelete = offsets.map { sectionChildren[$0] }
                // Perform any additional cleanup or deletion logic as needed
                // For example: delete them from a database or update your parent model
            }
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
                    let newChild = ModernListChild(parentId: parent.id, section: newChildSection.lowercased(), name: newChildName, icon: newChildTypedIcon)
                    // Add the new child to your model or perform any other necessary action
                    // For example: Save to a database or update your parent model
                    parent.child.append(newChild)
                    // Clear the input fields and close the sheet
                    newChildName = ""
                    newChildSection = ""
                    newChildTypedIcon = ""
                    isAddingChild = false
                })
                .padding()
            }
        }
        .padding()
    }

}

struct ModernChildRowView: View {
    @State var child: ModernListChild
    
    var body: some View {
        HStack{
            Button(action: {
                child.isDone.toggle()
                
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
