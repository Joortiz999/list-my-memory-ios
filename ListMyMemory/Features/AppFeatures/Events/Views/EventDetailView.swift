//
//  EventDetailView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    
    var body: some View {
        BaseView(title: Events.TodaysEvents, backButton: true, backButtonAction: {
            ScreenNavigation().redirectToScreen(nextView: HomeView(active: .event).environmentObject(sessionService))
        }, crossButton: false, crossButtonAction: {}, mainScreen: false, containsCapsule: false, content: {
            VStack(spacing: 20) {
                CustomImageViewResizable(inputImage: ImageConstants.Info)
                CustomLabel(text: Common.Information, font: AppFonts.NeoSansSemiBold16, foregroundColor: AppColors.Black)
                
                
            }
        })
        .padding(.horizontal, 16)
        .navigationBarHidden(true)
    }
}


