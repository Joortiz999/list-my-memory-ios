//
//  EventService.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 17/7/23.
//

import Foundation
import Combine
import Firebase
import FirebaseDatabase

enum EventKeys: String {
    case id
    case eventStatus
    case eventType
    case eventName
    case eventDescription
    case eventPlace
    case eventLocation
    case eventDate
    case eventTime
    case eventRecurrence
}

protocol EventService {
    func createEvent(with event: Event) -> AnyPublisher<Void, Error>
    func getAllEvents() -> AnyPublisher<[Event], Error>
    func getActiveEvents() -> AnyPublisher<[Event], Error>
    func getPeviousEvents() -> AnyPublisher<[Event], Error>
    func searchEventsByType(_ eventType: EventType) -> AnyPublisher<[Event], Error>
    func filterEventsByDate(_ date: Date) -> AnyPublisher<[Event], Error>
    func getSingleEvent(by id: String) -> AnyPublisher<Event, Error>
    func updateSingleEvent(with event: Event) -> AnyPublisher<Void, Error>
    func updatePassedEvent(with events: [Event]) -> AnyPublisher<Void, Error>
    func deleteEvent(by id: String) -> AnyPublisher<Void,Error>
}



final class EventServiceProvider: EventService {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private lazy var eventsDBPath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let eventRef = Database.database()
            .reference()
            .child("users/\(uid)/events")
        return eventRef
    }()
    


    private func parseEventDateTime(eventDate: String, eventTime: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        let eventDateTimeString = "\(eventDate) \(eventTime)"
        return dateFormatter.date(from: eventDateTimeString)
    }

    
    internal func createEvent(with event: Event) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    let error = NSError(domain: "eventsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                do {
                    let data = try self.encoder.encode(event)
                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        eventsDBPath.child(event.id).setValue(jsonObject) { error, _ in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    } else {
                        promise(.failure(NSError()))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    
    internal func getAllEvents() -> AnyPublisher<[Event], Error> {
        Deferred {
            Future<[Event], Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    let error = NSError(domain: "eventsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                eventsDBPath.observe(.value) { [weak self] snapshot in
                    guard let self = self else { return }
                    
                    var eventsList: [Event] = []
                    
                    if let snapshotValue = snapshot.value as? [String: Any] {
                        for (_, eventDict) in snapshotValue {
                            guard let eventJSON = eventDict as? [String: Any] else {
                                continue
                            }
                            
                            do {
                                let eventData = try JSONSerialization.data(withJSONObject: eventJSON)
                                let event = try self.decoder.decode(Event.self, from: eventData)
                                eventsList.append(event)
                            } catch {
                                promise(.failure(error))
                                return
                            }
                        }
                    }
                    promise(.success(eventsList))
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }

    
    internal func searchEventsByType(_ eventType: EventType) -> AnyPublisher<[Event], Error> {
        Deferred {
            Future<[Event], Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    promise(.failure(NSError()))
                    return
                }
                
                eventsDBPath.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self, let snapshotValue = snapshot.value as? [String: Any] else {
                        let error = NSError(domain: "Failed to retrieve snapshot", code: 0, userInfo: nil)
                        promise(.failure(error))
                        return
                    }
                    
                    var filteredEvents: [Event] = []
                    
                    for (_, eventDict) in snapshotValue {
                        guard let eventJSON = eventDict as? [String: Any] else {
                            continue
                        }
                        
                        do {
                            let eventData = try JSONSerialization.data(withJSONObject: eventJSON)
                            let event = try self.decoder.decode(Event.self, from: eventData)
                            
                            if event.eventType == eventType {
                                filteredEvents.append(event)
                            }
                        } catch {
                            promise(.failure(error))
                            return
                        }
                    }
                    
                    promise(.success(filteredEvents))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    internal func filterEventsByDate(_ date: Date) -> AnyPublisher<[Event], Error> {
        Deferred {
            Future<[Event], Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    let error = NSError(domain: "eventsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                eventsDBPath.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    
                    if let snapshotValue = snapshot.value as? [String: Any] {
                        var filteredEvents: [Event] = []
                        
                        for (_, eventDict) in snapshotValue {
                            guard let eventJSON = eventDict as? [String: Any] else {
                                continue
                            }
                            
                            do {
                                let eventData = try JSONSerialization.data(withJSONObject: eventJSON)
                                let event = try self.decoder.decode(Event.self, from: eventData)
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                
                                if let eventDate = dateFormatter.date(from: event.eventDate) {
                                    let calendar = Calendar.current
                                    let eventDateComponents = calendar.dateComponents([.year, .month, .day], from: eventDate)
                                    let inputDateComponents = calendar.dateComponents([.year, .month, .day], from: date)
                                    
                                    if eventDateComponents.year == inputDateComponents.year &&
                                        eventDateComponents.month == inputDateComponents.month &&
                                        eventDateComponents.day == inputDateComponents.day {
                                        filteredEvents.append(event)
                                    }
                                }
                            } catch {
                                promise(.failure(error))
                                return
                            }
                        }
                        
                        promise(.success(filteredEvents))
                    } else {
                        promise(.success([]))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }



    
    internal func getActiveEvents() -> AnyPublisher<[Event], Error> {
        Deferred {
            Future<[Event], Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    let error = NSError(domain: "eventsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                eventsDBPath.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    
                    if let snapshotValue = snapshot.value as? [String: Any] {
                        var activeEvents: [Event] = []
                        
                        for (_, eventDict) in snapshotValue {
                            guard let eventJSON = eventDict as? [String: Any] else {
                                continue
                            }
                            
                            // Check if the eventStatus is "active"
                            if let eventStatus = eventJSON["eventStatus"] as? String, eventStatus == "IN_PROGRESS" {
                                do {
                                    let eventData = try JSONSerialization.data(withJSONObject: eventJSON)
                                    let event = try self.decoder.decode(Event.self, from: eventData)
                                    activeEvents.append(event)
                                } catch {
                                    promise(.failure(error))
                                    return
                                }
                            }
                        }
                        
                        promise(.success(activeEvents))
                    } else {
                        promise(.success([]))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }


    internal func getPeviousEvents() -> AnyPublisher<[Event], Error> {
        Deferred {
            Future<[Event], Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    let error = NSError(domain: "eventsDBPath is nil", code: 0, userInfo: nil)
                    promise(.failure(error))
                    return
                }
                
                eventsDBPath.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self else { return }
                    
                    if let snapshotValue = snapshot.value as? [String: Any] {
                        var activeEvents: [Event] = []
                        
                        for (_, eventDict) in snapshotValue {
                            guard let eventJSON = eventDict as? [String: Any] else {
                                continue
                            }
                            
                            // Check if the eventStatus is "active"
                            if let eventStatus = eventJSON["eventStatus"] as? String, eventStatus == "DONE" {
                                do {
                                    let eventData = try JSONSerialization.data(withJSONObject: eventJSON)
                                    let event = try self.decoder.decode(Event.self, from: eventData)
                                    activeEvents.append(event)
                                } catch {
                                    promise(.failure(error))
                                    return
                                }
                            }
                        }
                        
                        promise(.success(activeEvents))
                    } else {
                        promise(.success([]))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    
    internal func getSingleEvent(by id: String) -> AnyPublisher<Event, Error> {
        Deferred {
            Future<Event, Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    promise(.failure(NSError()))
                    return
                }
                
                let eventRef = eventsDBPath.child(id)
                eventRef.observeSingleEvent(of: .value) { [weak self] snapshot in
                    guard let self = self, let eventJSON = snapshot.value as? [String: Any] else {
                        promise(.failure(NSError()))
                        return
                    }
                    
                    do {
                        let eventData = try JSONSerialization.data(withJSONObject: eventJSON)
                        let event = try self.decoder.decode(Event.self, from: eventData)
                        promise(.success(event))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    internal func updateSingleEvent(with event: Event) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    promise(.failure(NSError()))
                    return
                }
                
                do {
                    let data = try self.encoder.encode(event)
                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let eventRef = eventsDBPath.child(event.id)
                        eventRef.updateChildValues(jsonObject) { error, _ in
                            if let error = error {
                                promise(.failure(error))
                            } else {
                                promise(.success(()))
                            }
                        }
                    } else {
                        promise(.failure(NSError()))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func updatePassedEvent(with events: [Event]) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    promise(.failure(NSError()))
                    return
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"

                let group = DispatchGroup()

                for event in events {
                    guard let eventDate = dateFormatter.date(from: event.eventDate) else {
                                        // Invalid date format, skip this event
                                        continue
                                    }
                    // Compare event date with the current date
                    if eventDate < Date() {
                        // Event date has passed, update the event status to "DONE"
                        group.enter()
                        let updatedEvent = Event(id: event.id,
                                                 eventType: event.eventType,
                                                 eventStatus: .done,
                                                 eventName: event.eventName,
                                                 eventDescription: event.eventDescription,
                                                 eventDate: event.eventDate,
                                                 eventPlace: event.eventPlace,
                                                 eventLocation: event.eventLocation,
                                                 eventTime: event.eventTime)

                        do {
                            let data = try self.encoder.encode(updatedEvent)
                            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                let eventRef = eventsDBPath.child(event.id)
                                eventRef.updateChildValues(jsonObject) { error, _ in
                                    if let error = error {
                                        promise(.failure(error))
                                    } else {
                                        group.leave() // Mark the update as completed
                                    }
                                }
                            } else {
                                promise(.failure(NSError()))
                            }
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }

                group.notify(queue: .main) {
                    promise(.success(())) // All updates completed
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    internal func deleteEvent(by id: String) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                guard let eventsDBPath = self.eventsDBPath else {
                    promise(.failure(NSError()))
                    return
                }
                
                if id.isEmpty {
                    promise(.failure(NSError(domain: "Empty event ID", code: 400)))
                    return
                }
                
                let eventRef = eventsDBPath.child(id)
                eventRef.removeValue { error, _ in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}
