//
//  NavigationBarTitleView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation
import SwiftUI

struct BaseView<Content: View>: View {
    let title: LocalizedStringKey
    let backButton: Bool
    let backButtonAction: () -> Void
    let crossButton: Bool
    let crossButtonAction: () -> Void
    let mainScreen: Bool
    let containsCapsule: Bool
    let content : ()-> Content
    
    init(title: LocalizedStringKey, backButton: Bool, backButtonAction: @escaping () -> Void, crossButton: Bool, crossButtonAction: @escaping () -> Void, mainScreen: Bool, containsCapsule: Bool, @ViewBuilder content: @escaping () -> Content){
        self.title = title
        self.backButton = backButton
        self.backButtonAction = backButtonAction
        self.crossButton = crossButton
        self.crossButtonAction = crossButtonAction
        self.mainScreen = mainScreen
        self.containsCapsule = containsCapsule
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Button(action: {
                    if backButton {
                        backButtonAction()
                    }
                }, label: {
                    RenderingCustomImage(inputImage: backButton ? ImageConstants.LeftArrow : "", width: 32, height: 32, foregroundColor: mainScreen ? AppColors.Blue : AppColors.White)
                }).animation(.linear, value: backButton)
                Spacer()
                CustomLabel(text: title, font: .custom(mainScreen ? AppFonts.InterSemiBold : AppFonts.InterRegular, size: 14), foregroundColor: mainScreen ? AppColors.Blue : AppColors.White)
                Spacer()
                Button(action: {
                    if crossButton {
                        crossButtonAction()
                    }
                }, label: {
                    RenderingCustomImage(inputImage: crossButton ? ImageConstants.Close : "", width: 32, height: 32, foregroundColor: mainScreen ? AppColors.Blue : AppColors.White)
                })
            }
            .padding([.leading, .trailing], 16)
            .frame(maxWidth:.infinity,maxHeight: 64)
            .background(mainScreen ? AppColors.White : AppColors.Blue)
            if containsCapsule {
                CustomCapsule(color: AppColors.White, width: 48, height: 2)
            }
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        content()
                    }
                    .padding([.leading, .trailing, .bottom], 16)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.Blue)
    }
}


