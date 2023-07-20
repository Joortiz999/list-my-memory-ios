//
//  Event.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 5/4/23.
//

import Foundation
import Firebase

enum EventType: String, Codable {
    case personalActivity = "personal-activity"
    case socialActivity = "social-activity"
    case shopping = "shopping"
    case trip = "trip"
    case buisness = "buisness"
}

enum EventStatus: String, Codable{
    case done = "DONE"
    case inProgress = "IN_PROGRESS"
    case deleted = "DELETED"
}


struct Event: Identifiable, Codable , Hashable {
    var id: String
    var eventType: EventType
    var eventStatus: EventStatus
    var eventName: String
    var eventDescription: String
    var eventDate: String
    var eventPlace: String
    var eventLocation: String
    var eventTime: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case eventType
        case eventStatus
        case eventName
        case eventDescription
        case eventDate
        case eventPlace
        case eventLocation
        case eventTime
    }
    
    init(id: String, eventType: EventType, eventStatus: EventStatus, eventName: String, eventDescription: String, eventDate: String, eventPlace: String, eventLocation: String, eventTime: String) {
        self.id = id
        self.eventType = eventType
        self.eventStatus = eventStatus
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.eventDate = eventDate
        self.eventPlace = eventPlace
        self.eventLocation = eventLocation
        self.eventTime = eventTime
    }
}
extension Event {
    static var new: Event {
        Event(id: UUID().uuidString, eventType: .personalActivity, eventStatus: .inProgress, eventName: "", eventDescription: "", eventDate: "", eventPlace: "",eventLocation: "", eventTime: "")
    }
}
