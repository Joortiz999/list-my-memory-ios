//
//  EventSuggestionView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import SwiftUI

let suggestEvents = [
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Go Carts Racing", eventDescription: "Let's Get down to business speed racing in the go carts!", eventDate: "\(Date().nextDate())", eventPlace: "National Race Cart Field", eventLocation: "27th Street Highway Road", eventTime: "10:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Rock Climbing Adventure", eventDescription: "Get ready to conquer the vertical heights! Join us for a thrilling rock climbing experience.", eventDate: "\(Date().nextDate())", eventPlace: "Mountain Peak Adventures", eventLocation: "Mount Vertigo", eventTime: "09:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Beach Volleyball Tournament", eventDescription: "Bump, set, and spike your way to victory! Join our beach volleyball tournament for some sandy fun.", eventDate: "\(Date().nextDate())", eventPlace: "Sunny Shores Beach Club", eventLocation: "123 Sandy Lane", eventTime: "13:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Hiking in the Wilderness", eventDescription: "Explore the wonders of nature on this adventurous hike through the wilderness.", eventDate: "\(Date().nextDate())", eventPlace: "Wild Wanderers Trailhead", eventLocation: "Forest Reserve Road", eventTime: "08:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Paintball Mayhem", eventDescription: "Gear up and join us for an action-packed day of paintball battles!", eventDate: "\(Date().nextDate())", eventPlace: "Battlefield Paintball Arena", eventLocation: "1001 Paintball Drive", eventTime: "11:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Cooking Class Extravaganza", eventDescription: "Discover your inner chef in this fun and interactive cooking class.", eventDate: "\(Date().nextDate())", eventPlace: "Culinary Delights Institute", eventLocation: "5th Avenue, Chefville", eventTime: "15:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Photography Expedition", eventDescription: "Capture the beauty of nature on a photography expedition led by expert photographers.", eventDate: "\(Date().nextDate())", eventPlace: "Shutterbug Photography Club", eventLocation: "Aperture Street", eventTime: "07:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Escape Room Challenge", eventDescription: "Test your wits and teamwork in our thrilling escape room challenge.", eventDate: "\(Date().nextDate())", eventPlace: "Enigma Escape Rooms", eventLocation: "Mystery Avenue", eventTime: "14:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Yoga in the Park", eventDescription: "Relax your mind and body with a rejuvenating yoga session amidst the serenity of the park.", eventDate: "\(Date().nextDate())", eventPlace: "Zen Garden Park", eventLocation: "Lotus Lane", eventTime: "17:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Salsa Dance Night", eventDescription: "Put on your dancing shoes and join us for an electrifying night of salsa dancing.", eventDate: "\(Date().nextDate())", eventPlace: "Rhythm and Moves Dance Studio", eventLocation: "Dance Avenue", eventTime: "20:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Movie Marathon Madness", eventDescription: "Grab some popcorn and enjoy back-to-back blockbuster movies in our movie marathon.", eventDate: "\(Date().nextDate())", eventPlace: "Starlight Cinema", eventLocation: "Movie Street", eventTime: "16:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Board Games Bonanza", eventDescription: "Bring your favorite board games and join us for an afternoon of friendly competition.", eventDate: "\(Date().nextDate())", eventPlace: "Game Time Café", eventLocation: "Dice Alley", eventTime: "12:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Charity 5K Run", eventDescription: "Run for a cause and make a difference in the lives of those in need.", eventDate: "\(Date().nextDate())", eventPlace: "Hopeful Hearts Park", eventLocation: "Charity Lane", eventTime: "09:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Art and Wine Festival", eventDescription: "Indulge in a creative and cultural experience at our Art and Wine Festival.", eventDate: "\(Date().nextDate())", eventPlace: "Gallery Avenue", eventLocation: "Wine Valley", eventTime: "14:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Fitness Boot Camp", eventDescription: "Get fit and challenge yourself in our high-intensity fitness boot camp.", eventDate: "\(Date().nextDate())", eventPlace: "FitZone Gym", eventLocation: "Fitness Street", eventTime: "06:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Fashion Show Extravaganza", eventDescription: "Witness the latest trends and designs in our glamorous fashion show.", eventDate: "\(Date().nextDate())", eventPlace: "Fashionista Runway", eventLocation: "Chic Avenue", eventTime: "19:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Science and Technology Expo", eventDescription: "Explore the wonders of science and technology at our interactive expo.", eventDate: "\(Date().nextDate())", eventPlace: "Tech Hub Convention Center", eventLocation: "Innovation Road", eventTime: "10:30"),Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Karaoke Night", eventDescription: "Sing your heart out and enjoy a fun-filled karaoke night with friends.", eventDate: "\(Date().nextDate())", eventPlace: "Tunes & Cheers Lounge", eventLocation: "Sing-Along Street", eventTime: "21:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Farmers Market Fair", eventDescription: "Explore a variety of fresh produce and artisanal products at our Farmers Market Fair.", eventDate: "\(Date().nextDate())", eventPlace: "Green Acres Park", eventLocation: "Farmers Lane", eventTime: "08:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Gourmet Food Truck Festival", eventDescription: "Satisfy your taste buds with gourmet delights from a variety of food trucks.", eventDate: "\(Date().nextDate())", eventPlace: "Foodie Haven Street", eventLocation: "Culinary Corner", eventTime: "17:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Cultural Dance Showcase", eventDescription: "Experience the beauty and diversity of cultural dances from around the world.", eventDate: "\(Date().nextDate())", eventPlace: "Global Harmony Theater", eventLocation: "Cultural Avenue", eventTime: "19:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Mystery Murder Dinner", eventDescription: "Solve the mystery and enjoy a delicious dinner in our interactive murder mystery event.", eventDate: "\(Date().nextDate())", eventPlace: "Whodunit Manor", eventLocation: "Mystery Lane", eventTime: "18:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Kids Fun Day", eventDescription: "A day filled with games, activities, and fun for children of all ages.", eventDate: "\(Date().nextDate())", eventPlace: "Happy Kids Park", eventLocation: "Playground Street", eventTime: "10:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Outdoor Painting Workshop", eventDescription: "Unleash your creativity and paint beautiful landscapes in our outdoor workshop.", eventDate: "\(Date().nextDate())", eventPlace: "Nature's Canvas", eventLocation: "Artistic Trails", eventTime: "14:00"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Comedy Night", eventDescription: "Laugh out loud with hilarious stand-up comedy performances by top comedians.", eventDate: "\(Date().nextDate())", eventPlace: "The Comedy Club", eventLocation: "Humor Street", eventTime: "20:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Teddy Bear Picnic", eventDescription: "Bring your favorite teddy bear and enjoy a delightful picnic in the park.", eventDate: "\(Date().nextDate())", eventPlace: "Teddyville Park", eventLocation: "Cuddly Lane", eventTime: "12:30"),
    Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "Cosplay Convention", eventDescription: "Celebrate your favorite characters and immerse yourself in the world of cosplay.", eventDate: "\(Date().nextDate())", eventPlace: "Cosplay Universe", eventLocation: "Fantasy Avenue", eventTime: "11:00"),]

struct EventSuggestionView: View {
    @EnvironmentObject var sessionService: SessionServiceProvider
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView{
            ZStack {
                AppColors.White.ignoresSafeArea(.all, edges: .all)
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                CustomImageViewResizable(inputImage: ImageConstants.LeftArrow, color: AppColors.Orange).frame(width: 40, height: 40)
                            }
                            Spacer()
                            Button(action: {
                                // Help Button
                            }) {
                                CustomImageViewResizable(inputImage: ImageConstants.Help, color: AppColors.Orange).frame(width: 40, height: 40)
                            }
//                            Button(action: {
//                                // Share Button
//                            }) {
//                                CustomImageViewResizable(inputImage: ImageConstants.Notification, color: AppColors.Green).frame(width: 40, height: 40)
//                            }
                        }.padding(16)
                        CustomLabelString(text: "Event Suggestions", font: .title.bold(), foregroundColor: AppColors.Orange)
                            .padding(.vertical, 16)
                    }
                    ZStack {
                        Group {
                            LinearGradient(
                                colors: [AppColors.White, AppColors.White, AppColors.Orange],
                                startPoint: .top,
                                endPoint: .bottom
                            ).cornerRadius(20).ignoresSafeArea()
                        }
                        VStack {
                            ScrollView{
                                ForEach(suggestEvents, id: \.self) { events in
                                    
                                    Button(action: {
                                        ScreenNavigation().redirectToScreen(nextView: CreateEventView(title: Events.EventSuggestions, eventSuggested: events).environmentObject(sessionService))
                                    }, label: {
                                        HStack{
                                            VStack{
                                                Text(events.eventName).font(.caption.bold())
                                                Text(events.eventPlace).font(.caption.bold())
                                                Text(events.eventTime).font(.body.bold())
                                            }.padding(12).frame(width: 210, height: 100, alignment: .center)
                                            Spacer()
                                            Divider().frame(width: 3, height: 80)
                                                .overlay(AppColors.White)
                                            CustomImageViewResizable(inputImage: ImageConstants.Calendar, color: AppColors.White)
                                                .frame(width: 60, height: 60).padding(12)
                                        }
                                        .frame(maxWidth: 320, maxHeight: 120, alignment: .leading)
                                    })
                                    .background(AppColors.Orange.opacity(0.4))
                                    .foregroundColor(AppColors.White)
                                    .font(.body.bold())
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(AppColors.White.opacity(0.8), lineWidth: 3)
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.clear)
        }
    }
    
}

struct EventSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        EventSuggestionView().preview(with: "Events dashboard")
    }
}
