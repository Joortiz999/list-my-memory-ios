//
//  SharingView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 30/7/23.
//

import Foundation
import SwiftUI

struct SharingView: View {
    let action: () -> Void
    
    init(action:@escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 12){
            CustomImageViewResizable(inputImage: ImageConstants.Share, color: AppColors.Blue).frame(width: 40, height: 40)
        }.padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
            .background(AppColors.Blue.opacity(0.1))
        .cornerRadius(24)
        .onTapGesture {
            action()
        }
    }
}
