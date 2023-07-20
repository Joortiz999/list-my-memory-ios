//
//  CreateEventView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 25/3/23.
//

import Foundation
import SwiftUI

struct CreateEventView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @StateObject private var eventVM = EventViewModelProvider(service: EventServiceProvider())
    @State var pickerTypeSelection: EventType = .personalActivity
    @State var pickerDateSelection: Date = Date().nextDate()
    typealias ActionHandler = () -> Void
    var title: LocalizedStringKey
    var selection = Date()
    
    init(title: LocalizedStringKey) {
        self.title = title
    }
    
    var body: some View {
        BaseView(title: title, backButton: true, backButtonAction: {
            ScreenNavigation().redirectToScreen(nextView: HomeView(active: .home).environmentObject(sessionService))
        }, crossButton: false, crossButtonAction: {}, mainScreen: false, containsCapsule: false, content: {
                    VStack(spacing: 30) {
                        contentTop
                        contentMiddle
                        contentButton
                    }.padding(.vertical, 10)
                .background(AppColors.Blue.opacity(0.8), ignoresSafeAreaEdges: .all)
            
        })
    }
    
    private var contentTop: some View {
        VStack {
            CustomLabelString(text: "Event Title", font: .title2.bold(), foregroundColor: AppColors.White)
            InputTextFieldView(text: $eventVM.eventDetails.eventName, placeholder: "add a name for new event", keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 5,cornerRadius: 30, sfSymbol: nil)
                .foregroundColor(AppColors.Black)
//                .background(AppColors.White)
            
            HStack{
                CustomLabelString(text: "type of event:", font: .body.bold(), foregroundColor: AppColors.White)
                Picker("", selection: $pickerTypeSelection) {
                    Group{
                        Text(EventType.personalActivity.rawValue).tag(EventType.personalActivity)
                        Text(EventType.socialActivity.rawValue).tag(EventType.socialActivity)
                        Text(EventType.trip.rawValue).tag(EventType.trip)
                        Text(EventType.shopping.rawValue).tag(EventType.shopping)
                        Text(EventType.buisness.rawValue).tag(EventType.buisness)
                    }.font(.body.bold())
                }
                .pickerStyle(.wheel)
                .frame(width: 220,height: 55)
                .background(AppColors.Blue)
                .foregroundColor(AppColors.White)
                .opacity(0.8)
                .cornerRadius(10)
                .background(
                    ZStack(alignment: .leading, content: {
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .stroke(AppColors.White.opacity(0.8), lineWidth: 3)
                    })
                )
            }.padding(.vertical, 14)
            VStack{
                CustomLabelString(text: "place for event:", font: .body.bold(), foregroundColor: .white)
                InputTextFieldView(text: $eventVM.eventDetails.eventPlace, placeholder: "choose a place for the event", keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 5,cornerRadius: 30, sfSymbol: nil)
                    .foregroundColor(AppColors.Black)

                CustomLabelString(text: "location of event:", font: .body.bold(), foregroundColor: .white)
                InputTextFieldView(text: $eventVM.eventDetails.eventLocation, placeholder: "add a location to the event", keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 5, cornerRadius: 30, sfSymbol: nil)
                    .foregroundColor(AppColors.Black)

            }
        }
    }
    private var contentMiddle: some View {
        VStack {
            CustomLabelString(text: "date and Time for event:", font: .body.bold(), foregroundColor: .white)
            DatePicker("", selection: $pickerDateSelection, displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.wheel)
                .frame(width: 320,height: 265)
                .background(AppColors.Blue)
                .foregroundColor(AppColors.White)
                .opacity(0.8)
                .cornerRadius(10)
                .background(
                    ZStack(alignment: .leading, content: {
                        RoundedRectangle(cornerRadius: 10, style: .circular)
                            .stroke(AppColors.White.opacity(0.8), lineWidth: 3)
                    })
                )
            CustomLabelString(text: "event description", font: .body.bold(), foregroundColor: .white)
            LargeInputTextFieldView(text: $eventVM.eventDetails.eventDescription, placeholder: "add a description to your event..", keyboardType: .namePhonePad, borderColor: AppColors.White, borderWidth: 5,cornerRadius: 10)
                .foregroundColor(AppColors.Black)
        }
    }
    private var contentButton: some View {
        VStack {
            SecondaryButtonView(title: Buttons.Continue, image: nil, imageColor: nil, background: AppColors.White,foreground: AppColors.Blue, border: AppColors.Blue.opacity(0.8),height: 75, width: 300, handler: {
                eventVM.eventDetails.eventDate = pickerDateSelection.toString(format: "yyyy-MM-dd")
                eventVM.eventDetails.eventTime = pickerDateSelection.timeIn24HourFormat()
                eventVM.eventDetails.eventType = pickerTypeSelection
                eventVM.createEvent(with: eventVM.eventDetails)
                ScreenNavigation().redirectToScreen(nextView: HomeView(active: .home).environmentObject(sessionService))
            })
        }
    }
}

