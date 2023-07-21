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
    @StateObject private var eventVM = EventViewModelProvider(service: EventServiceProvider())
    @StateObject private var taskVM = ListViewModelProvider(service: ListServiceProvider())
    @State var isShowingNewEvent: Bool = false
    @State var showEventSuggestion: Bool = false
    
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
                settingsView
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
        }
    }
    
    private var homeView: some View {
        VStack{
            HStack{
                    CustomLabel(text: Common.Hello, font: AppFonts.InterBold16, foregroundColor: AppColors.Black)
                CustomLabelString(text: self.sessionService.userDetails?.firstName ?? "User", font: AppFonts.InterBold16, foregroundColor: AppColors.Black)
                
            }.padding(.vertical, 10).frame(width: 320, alignment: .leading)
            HStack(spacing: 16){
                SecondaryButtonView(title: Events.NewEvents,image: ImageConstants.Add, imageColor: AppColors.Black.opacity(0.7), background: AppColors.Blue.opacity(0.8), foreground: AppColors.Black, height: 100, width: 170, handler: {
                    ScreenNavigation().redirectToScreen(nextView: CreateEventView(title: Events.NewEvents, eventSuggested: Event.new).environmentObject(sessionService))
                })
                SecondaryButtonView(title: Events.EventSuggestions,image: ImageConstants.Eye, imageColor: AppColors.Black.opacity(0.7), background: AppColors.Orange.opacity(0.7),foreground: AppColors.Black, height: 100, width: 220, handler: {
                    print("Feature under Development")
                    // present sheet
                    showEventSuggestion.toggle()
                })
                .sheet(isPresented: $showEventSuggestion) {
                    EventSuggestionView()
                }
                
            }.padding(.horizontal, 16)
            VStack {
                HStack{
                    Group{
                    CustomImageViewResizable(inputImage: ImageConstants.RightArrow, color: AppColors.Red).frame(width: 25, height: 25)
                    VStack{
                        Divider().frame(width: 30,height: 2)
                            .overlay(AppColors.Red)
                    }
                    CustomImageViewResizable(inputImage: ImageConstants.RightArrow, color: AppColors.Red).frame(width: 25, height: 25)
                    VStack{
                        Divider().frame(width: 30,height: 2)
                            .overlay(AppColors.Red)
                    }
                    CustomImageViewResizable(inputImage: ImageConstants.RightArrow, color: AppColors.Red).frame(width: 25, height: 25)
                    }
                    CustomLabel(text: Events.UpcommingEvents, font: .body.bold(), foregroundColor: AppColors.Red).lineLimit(1)
                }.frame(width: 340, alignment: .trailing)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(0...6, id: \.self) { index in
                            let day = startDay.nextDate(by: index)
                            WeeklyDaysRowView(weekDayHumanReadable: day.getHumanReadableDayString(), weekDay: day.daytoString(), backgroundColor: eventVM.foundEventDate != day ? AppColors.Red.opacity(0.8) : AppColors.Red, borderColor: AppColors.White.opacity(0.8)) {
                                eventVM.getEventsByDate(date: day)
//                                print("filtering by \(day.getHumanReadableDayString()), \(day.daytoString())")
                            }
                        }
                    }
                }.padding(.horizontal, 16)
            }
            .onAppear{
                eventVM.getEventsByDate(date: Date.now)
            }
            VStack{
                if !eventVM.events.isEmpty {
                    CustomLabelString(text: eventVM.foundEventDate?.toString(format: "EEEE, MMM d, yyyy") ?? "", font: .title.bold(), foregroundColor: AppColors.Red)
                    ScrollView(showsIndicators: false){
                        ForEach(eventVM.events, id: \.self) { fE in
                            
                            Button(action: {
                                ScreenNavigation().redirectToScreen(nextView: EventDetailView(event: fE, fromScreen: ScreenNames.homeScreen).environmentObject(sessionService))
                            }, label: {
                                HStack{
                                    VStack{
                                        Text(fE.eventName)
                                        Text(fE.eventTime)
                                        Text(fE.eventPlace)
                                        Text(fE.eventType.rawValue)
                                    }.padding(12).frame(width: 210, height: 100, alignment: .center)
                                    Spacer()
                                    Divider().frame(width: 3, height: 80)
                                        .overlay(AppColors.White)
                                    CustomImageViewResizable(inputImage: ImageConstants.Info, color: AppColors.White)
                                        .frame(width: 60, height: 60).padding(12)
                                }
                                .frame(maxWidth: 320, maxHeight: 120, alignment: .leading)
                            })
                            .background(AppColors.Red)
                            .foregroundColor(AppColors.White)
                            .font(.body.bold())
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppColors.White.opacity(0.8), lineWidth: 3)
                            )
                        }
                    }
                } else {
                    VStack(spacing: 10){
                        CustomImageViewResizable(inputImage: ImageConstants.Wrong, color: AppColors.Red.opacity(0.7)).frame(width: 80, height: 80)
                        CustomLabelString(text: "No events found on", font: .title3.bold(), foregroundColor: AppColors.Red.opacity(0.7))
                        CustomLabelString(text: "\(eventVM.foundEventDate?.getHumanReadableDayString() ?? startDay.getHumanReadableDayString()), \(eventVM.foundEventDate?.daytoString() ?? startDay.daytoString())", font: .title.bold(), foregroundColor: AppColors.Red)
                    }.padding(.top, 80).scenePadding(.all)
                }
            }
            Spacer()
        }
    }
    private var eventsView: some View {
        VStack{
            VStack{
                HStack(spacing: 4){
                    SecondaryButtonView(title: eventVM.appliedFilter == .active ? Events.TodaysEvents : Events.ActiveEvents ,image: ImageConstants.Flag, imageColor: AppColors.White, background: AppColors.Blue.opacity(0.7), height: 55, width: 230, handler: {
                        if eventVM.appliedFilter != .todays  {
                            eventVM.appliedFilter = .todays
                            eventVM.getEventsByDate(date: Date())
                        } else {
                            eventVM.appliedFilter = .active
                            eventVM.getActiveEvents()
                        }
                    })
                    Spacer()
                    SecondaryButtonView(title: "fitImage",image: ImageConstants.History, imageColor: AppColors.White, background: AppColors.Blue.opacity(0.7), height: 55, width: 120, handler: {
                        if eventVM.appliedFilter != .all && eventVM.appliedFilter != .done {
                            eventVM.appliedFilter = .all
                            eventVM.getEvents()
                        } else if eventVM.appliedFilter == .all {
                            eventVM.appliedFilter = .done
                            eventVM.getPreviousEvents()
                        } else {
                            eventVM.appliedFilter = .active
                            eventVM.getActiveEvents()
                        }
                    })
                    
                }
                Spacer()
                ScrollView {
                    if !eventVM.events.isEmpty {
                        CustomLabelString(text: eventVM.appliedFilter.rawValue, font: .title2.bold(), foregroundColor: AppColors.Blue).padding(.top, 25).frame(width: 320, alignment: .leading)
                        
                        ForEach(eventVM.events, id: \.id) { event in
                            EventRowView(eventName: event.eventName , eventDescription: event.eventDescription , eventPlace: event.eventPlace , backgroundColor: AppColors.Blue.opacity(0.7), borderColor: AppColors.White) {
                                    self.active = .event
                                ScreenNavigation().redirectToScreen(nextView: EventDetailView(event: event, fromScreen: ScreenNames.EventsScreen).environmentObject(sessionService))
                                }
                        }
                        
                    } else {
                        CustomImageViewResizable(inputImage: ImageConstants.Wrong, color: AppColors.Blue.opacity(0.7)).frame(width: 80, height: 80).padding(.top, 80)
                        CustomLabelString(text: "\(eventVM.appliedFilter.rawValue)\nare empty.", font: .title.bold(), foregroundColor: AppColors.Blue).scenePadding(.all)
                        CustomLabelString(text: "Add new events by\ntaping here, and filling\nthe desire event form.", font: .body.bold(), foregroundColor: AppColors.Blue).scenePadding(.all).onTapGesture {
                            ScreenNavigation().redirectToScreen(nextView: CreateEventView(title: Events.NewEvents, eventSuggested: Event.new).environmentObject(sessionService))
                        }
                    }
                }.padding(.horizontal, 7)
            }
        }.padding(.horizontal, 16)
            .onAppear{
                eventVM.getActiveEvents()
            }
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
            SecondaryButtonView(title: "fitImage", image: ImageConstants.LogOut, imageColor: AppColors.Purple, background: AppColors.White, foreground: AppColors.Purple, border: AppColors.Purple,height: 80, width: 80, handler: {
                sessionService.logout()
            })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        
        HomeView(active: .home)
            .environmentObject(SessionServiceProvider())
    }
}

