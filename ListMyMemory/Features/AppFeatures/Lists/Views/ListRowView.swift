//
//  ListRowView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 16/7/23.
//

import SwiftUI

struct ListRowView: View {
    @StateObject private var taskVM = ListViewModelProvider(service: ListServiceProvider())
    typealias ActionHandler = () -> Void
    
    var task: BaseList
    var handler : ActionHandler
    
    init(task: BaseList, handler: @escaping ListRowView.ActionHandler) {
        self.task = task
        self.handler = handler
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                .fill(AppColors.Green.opacity(0.7))
                .frame( height: 100)
            Button(action: handler, label: {
                VStack(alignment: .leading){
                    HStack(alignment: .center){
                        CustomImageViewResizable(inputImage: ImageConstants.Crown, color: AppColors.White)
                            .frame(width: 40, height: 40, alignment: .center).padding(.horizontal, 5)
                        Divider()
                            .frame(width: 2, height: 60)
                            .overlay(AppColors.White)
                        VStack {
                            Text("\(task.name)")
                                .foregroundColor(AppColors.White)
                                .font(.title.bold())
                        }
                        Spacer()
                        CustomImageViewResizable(inputImage: ImageConstants.RightArrow, color: AppColors.White).frame(width: 40, height: 40, alignment: .center)
                    }
                    
                }.padding(.horizontal, 16)
            })
        }
    }
}
