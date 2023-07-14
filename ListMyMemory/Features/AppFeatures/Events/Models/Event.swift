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
    var eventDate: Date
    var eventPlace: String
    var eventDescription: String
    var eventRating: Double
    var recurrence: Bool
    
}

extension Event {
    static var new: Event {
        Event(id: UUID().uuidString, eventType: "", eventTitle: "", eventDate: Date(), eventPlace: "", eventDescription: "", eventRating: 0.0, recurrence: false)
    }
    
}

