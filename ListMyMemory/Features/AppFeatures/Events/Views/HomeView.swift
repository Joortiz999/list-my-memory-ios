//
//  EventDashboard.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

public enum ActiveNavigation: Int {
    case home = 0
    case event = 1
    case task = 2
    case settings = 3
    case other = 4
}

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @State var isShowingNewEvent: Bool = false
    
    @State var active: ActiveNavigation = .task
    let startDay = Date()
    
    var body: some View {
        
        VStack {
            Text("List My Memory").font(.caption)
                .bold()
            TabView(selection: $active){
                homeView
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }.tag(ActiveNavigation.home)
                eventsView
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "bookmark.circle.fill")
                        Text("Events")
                    }.tag(ActiveNavigation.event)
                tasksView
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard.fill")
                        Text("Tasks")
                    }.tag(ActiveNavigation.task)
                Text("Settings Commig soon..")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        VStack{
                            Image(systemName: "switch.2")
                            Text("Settings")
                        }
                    }.tag(ActiveNavigation.settings)
            }.tabViewStyle(.automatic)
                .accentColor(active == .home ? AppColors.Red : active == .event ? AppColors.Blue : active == .task ? AppColors.Green : active == .settings ? AppColors.Purple : AppColors.Black)
                .navigationBarBackButtonHidden()
            Text("\(active.rawValue)")
        }
    }
    
    private var homeView: some View {
        VStack{
            HStack{
                CustomLabel(text: Common.Hello, font: AppFonts.InterBold16, foregroundColor: AppColors.Black)
                CustomLabelString(text: self.sessionService.userDetails?.firstName ?? "User", font: AppFonts.InterBold16, foregroundColor: AppColors.Black)
                
            }
            HStack(spacing: 16){
                SecondaryButtonView(title: Events.NewEvents,image: ImageConstants.Add, imageColor: AppColors.White, height: 100, width: 170, handler: {
                    self.active = .home
                    ScreenNavigation().redirectToScreen(nextView: CreateEventView(title: Events.NewEvents){
                        
                    }.environmentObject(sessionService))
                })
                SecondaryButtonView(title: Events.EventSuggestions,image: ImageConstants.Eye, imageColor: AppColors.White, background: AppColors.Red, height: 100, width: 220, handler: {
                    
                })
                
            }.padding(.horizontal, 16)
            VStack {
                CustomLabel(text: Events.UpcommingEvents, font: AppFonts.NeoSansBold14, foregroundColor: AppColors.Purple).frame(alignment: .leading)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        
                        ForEach(0...6, id: \.self) { index in
                            let day = startDay.nextDate(by: index)
                            WeeklyDaysRowView(weekDayHumanReadable: day.getHumanReadableDayString(), weekDay: day.daytoString(), backgroundColor: AppColors.White, borderColor: AppColors.Purple) {
                                print("filtering by day \(day.getHumanReadableDayString()), \(day.daytoString())")
                            }
                        }
                    }
                }.padding(.horizontal, 16)
            }
            Spacer()
            Text("DashBoard")
        }
    }
    private var eventsView: some View {
        VStack{
            VStack{
                HStack(spacing: 4){
                    SecondaryButtonView(title: Events.TodaysEvents,image: ImageConstants.Flag, imageColor: AppColors.White, height: 55, width: 180, handler: {
                        
                    })
                    SecondaryButtonView(title: Events.UpcommingEvents,image: ImageConstants.History, imageColor: AppColors.White, background: AppColors.Red, height: 55, width: 180, handler: {
                        
                    })
                    
                }
                Spacer()
                ScrollView {
                    ForEach(0...3, id: \.self) {_ in
                        EventRowView(eventName: Event.new.eventTitle, eventDescription: Event.new.eventDescription, eventPlace: Event.new.eventPlace, backgroundColor: AppColors.Blue, borderColor: AppColors.White) {
                            self.active = .event
                            ScreenNavigation().redirectToScreen(nextView: EventDetailView().environmentObject(sessionService))
                        }
                    }
                }.padding(.horizontal, 7)
            }
        }.padding(.horizontal, 16)
    }
    private var tasksView: some View {
        VStack{
            HStack(spacing: 4){
                CustomLabelString(text: "Tasks", font: .title.bold(), foregroundColor: AppColors.Green)
                Spacer()
                SecondaryButtonView(title: "fitImage" ,image: ImageConstants.Info, imageColor: AppColors.Green, background: AppColors.White, height: 55, width: 55, handler: {
                    
                })
            }
            Spacer()
            VStack (spacing: 20){
                ListsView()
                    
            }.background(AppColors.White, ignoresSafeAreaEdges: [.bottom])
            
        }.padding(.horizontal, 16)
    }
    private var settingsView: some View {
        VStack{
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeView(active: .home)
            .environmentObject(SessionServiceProvider())
    }
}

