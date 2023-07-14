//
//  EventDashboard.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import SwiftUI

struct EventsView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @State var isShowingNewEvent: Bool = false
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Welcome \(sessionService.userDetails?.firstName ?? "N/A ") \(sessionService.userDetails?.lastName ?? "N/A")")
                
            }
            
            NavigationStack {
                            List {
                                ForEach((0...5), id: \.self) { item in
                                    
                                    ZStack(alignment: .leading) {
                                        NavigationLink(destination: EventDetailView()) {
                                            EmptyView()
                                        }.opacity(0)
                                        
                                        EventRowView()
                                    }
                                    
                                }
                            }.listStyle(.plain)
            }.toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingNewEvent.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                    }
                    
                }
                
            }
            
            .sheet(isPresented: $isShowingNewEvent) {
                NavigationStack {
                    CreateEventView()
                }
            }
            
            
            PrimaryButtonView(title: "Logout") {
                sessionService.logout()
            }
            
        }
        .padding(.horizontal, 16)
        .navigationTitle("Events")
//        .redacted(reason: .placeholder)
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            EventsView()
                .environmentObject(SessionServiceProvider())
        }
    }
}
