//
//  CloseModifier.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct CloseModifier: ViewModifier {
    
    @Environment(\.presentationMode) var presentationMode
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack{
                        CustomImageViewResizable(inputImage: ImageConstants.LeftArrow, color: AppColors.White).frame(width: 40, height: 40)
                    }
                })
            }
    }
}

extension View {
    func applyClose() -> some View {
        self.modifier(CloseModifier())
    }
}
