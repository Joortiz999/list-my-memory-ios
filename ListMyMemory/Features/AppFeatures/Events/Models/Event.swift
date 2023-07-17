//
//  Event.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 5/4/23.
//

import Foundation

struct Event: Identifiable {
    var id: String
    var eventType: String
    var eventTitle: String
    var eventDate: String
    var eventPlace: String
    var eventDescription: String
    var eventRating: Double
    var recurrence: Bool
    
}

extension Event {
    static var new: Event {
        Event(id: UUID().uuidString, eventType: "event-type", eventTitle: "event-title", eventDate: Date().toString(), eventPlace: "event-place", eventDescription: "event-description", eventRating: 0.0, recurrence: false)
    }
    
}

