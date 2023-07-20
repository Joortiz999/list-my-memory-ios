//
//  EventDetailView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    var event: Event
    var fromScreen: String = ""
    
    var body: some View {
        ZStack{
            AppColors.Black.ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 0){
                VStack{
                    HStack{
                        Button(action: {
                            if fromScreen == ScreenNames.EventsScreen {
                                ScreenNavigation().redirectToScreen(nextView: HomeView(active: .event).environmentObject(sessionService))
                            } else {
                                ScreenNavigation().redirectToScreen(nextView: HomeView(active: .home).environmentObject(sessionService))
                            }
                        }, label: {
                            CustomImageViewResizable(inputImage: ImageConstants.LeftArrow, color: AppColors.White).frame(width: 40, height: 40)
                        })
                        Spacer()
                        Button(action: {
                            // Share Button
                        }, label: {
                            CustomImageViewResizable(inputImage: ImageConstants.Help, color: AppColors.White).frame(width: 40, height: 40)
                        })
                        Button(action: {
                            // Share Button
                        }, label: {
                            CustomImageViewResizable(inputImage: ImageConstants.Notification, color: AppColors.White).frame(width: 40, height: 40)
                        })
                    }.padding(16)
                    CustomLabelString(text: "\(event.eventName)", font: .title.bold(), foregroundColor: AppColors.White)
                        .padding(.top, 16)
                }
                ZStack{
                    Group{
                        LinearGradient(
                            colors: [AppColors.White, AppColors.White, AppColors.Blue],
                            startPoint: .top,
                            endPoint: .bottom
                        ).cornerRadius(20).ignoresSafeArea()
                    }
                    
                    ScrollView(showsIndicators: false){
                        Image(ImageConstants.LargeImage)
                            .resizable()
                                .frame(maxWidth: .infinity,maxHeight: 160).cornerRadius(8.0)
                                .aspectRatio(contentMode: .fit).padding([.horizontal, .top], 16)
                        HStack{
                            CustomLabelString(text: "Type:", font: .title2.bold(), foregroundColor: AppColors.Black).frame(alignment: .leading)
                            Spacer()
                            CustomLabelString(text: "\(event.eventType)", font: .title2.bold(), foregroundColor: AppColors.Black).frame(alignment: .trailing)
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding([.horizontal, .vertical], 16)
                        Divider()
                            .frame(width: 330, height: 2)
                            .overlay(AppColors.Blue)
                        HStack{
                            CustomLabelString(text: "Status:", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .leading)
                            Spacer()
                            CustomLabelString(text: "\(event.eventStatus)", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .trailing)
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding([.horizontal, .vertical], 16)
                        Divider()
                            .frame(width: 330, height: 2)
                            .overlay(AppColors.Blue)
                        HStack{
                            CustomLabelString(text: "When:", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .leading)
                            Spacer()
                            CustomLabelString(text: "\(event.eventDate) \(event.eventTime)", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .trailing)
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding([.horizontal, .vertical], 16)
                        Divider()
                            .frame(width: 330, height: 2)
                            .overlay(AppColors.Blue)
                        HStack{
                            CustomLabelString(text: "Where:", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .leading)
                            Spacer()
                            VStack{
                                HStack{
                                    Spacer()
                                    CustomLabelString(text: "\(event.eventPlace)", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .trailing)
                                }
                                HStack{
                                    Spacer()
                                    CustomLabelString(text: "\(event.eventLocation)", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .trailing)
                                }
                            }
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding([.horizontal, .vertical], 16)
                        Divider()
                            .frame(width: 330, height: 2)
                            .overlay(AppColors.Blue)
                        VStack{
                            HStack{
                                CustomLabelString(text: "Description:", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .topLeading)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                CustomLabelString(text: "\(event.eventDescription)", font: .title3.bold(), foregroundColor: AppColors.Black).frame(alignment: .leading).padding(16)
                                Spacer()
                            }
                            
                            
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading).padding([.horizontal, .vertical], 16)
                        
                    }.padding([.vertical, .horizontal], 16)
                }
                .padding(.top, 26)
            }
        }
    }
}


