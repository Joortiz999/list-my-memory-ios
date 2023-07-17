//
//  ListRowView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 16/7/23.
//

import SwiftUI

struct ListRowView: View {
    
    typealias ActionHandler = () -> Void
    
    @State var task: Task
    var roundedTop: Bool
    var roundedBottom: Bool
    var handler : ActionHandler
    
    init(task: Task, roundedTop: Bool, roundedBottom: Bool, handler: @escaping ListRowView.ActionHandler) {
        self.task = task
        self.roundedTop = roundedTop
        self.roundedBottom = roundedBottom
        self.handler = handler
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                .fill(AppColors.Green)
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
                            Text("\(task.taskItem)")
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
