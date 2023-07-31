//
//  EventViewModel.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 18/7/23.
//

import Foundation
import Combine

protocol EventViewModel {
    var service: EventService { get }
    var eventDetails: Event { get set }
    var events: [Event] { get set }
    
    init(service: EventService)
    
    func createEvent(with event: Event)
    func getEvents()
    func getActiveEvents()
    func getPreviousEvents()
    func searchEventsByType(eventType: EventType)
    func getEventsByDate(date: Date)
    func getSingleEvent(id: String)
    func deleteEvent(id: String)
    func updateEvent(event: Event)
}

enum EventAppliedFilter: String {
    case all = "All Events"
    case active = "Active Events"
    case done = "Done Events"
    case todays = "Today's Events"
    
    case personal = "Personal Events"
    case social = "Social Events"
    case shopping = "Shopping Events"
    case trip = "Trip Events"
    case buisness = "Buisness Events"
}

final class EventViewModelProvider: ObservableObject, EventViewModel {
    
    var appliedFilter: EventAppliedFilter = .active
    var foundEventDate: Date?
    
    let service: EventService
    @Published var events: [Event] = []
    @Published var eventDetails: Event = Event.new
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: EventService) {
        self.service = service
    }

    public func getEventsByDate(date: Date) {
        service.filterEventsByDate(date)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.foundEventDate = date
                self.events = data.sorted(by: {$0.eventDate > $1.eventDate})
                // Perform any additional UI updates or completion handling here
            })
            .store(in: &subscriptions)
    }

    func createEvent(with event: Event) {
        service.createEvent(with: event)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    print("Successfully created new event!")
                    // Handle successful completion if needed.
                }
            }, receiveValue: { _ in
                // The receiveValue will not be called in this case, as the createList function returns Void.
            })
            .store(in: &subscriptions)
    }

    func getEvents() {
        service.getAllEvents()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.events = data.sorted(by: {$0.eventDate > $1.eventDate})
                // Perform any additional UI updates or completion handling here
                self.updatePassedEvents(events: data)
            })
            .store(in: &subscriptions)
    }

    func getActiveEvents() {
        service.getActiveEvents()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.events = data.sorted(by: {$0.eventDate > $1.eventDate})
                // Perform any additional UI updates or completion handling here
            })
            .store(in: &subscriptions)
    }

    func getPreviousEvents() {
        service.getPeviousEvents()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.events = data.sorted(by: {$0.eventDate > $1.eventDate})
                // Perform any additional UI updates or completion handling here
            })
            .store(in: &subscriptions)
    }

    func searchEventsByType(eventType: EventType) {
        service.searchEventsByType(eventType)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.events = data.sorted(by: {$0.eventDate > $1.eventDate})
                // Perform any additional UI updates or completion handling here
            })
            .store(in: &subscriptions)
    }

    func getSingleEvent(id: String) {
        service.getSingleEvent(by: id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    break
                }
            }, receiveValue: { data in
                self.eventDetails = data
                // Perform any additional UI updates or completion handling here
            })
            .store(in: &subscriptions)
    }

    func deleteEvent(id: String) {
        service.deleteEvent(by: id)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    print("Event deleted successfully.")
                    // Handle successful completion if needed.
                }
            }, receiveValue: { _ in
                // The receiveValue will not be called in this case, as the createList function returns Void.
            })
            .store(in: &subscriptions)
    }

    func updateEvent(event: Event) {
        service.updateSingleEvent(with: event)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    print("Event updated successfully.")
                    // Handle successful completion if needed.
                }
            }, receiveValue: { _ in
                // The receiveValue will not be called in this case, as the createList function returns Void.
            })
            .store(in: &subscriptions)
    }
    
    private func updatePassedEvents(events: [Event]){
        service.updatePassedEvent(with: events)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    print("Failed: \(err)")
                case .finished:
                    print("Event updated successfully.")
                    // Handle successful completion if needed.
                }
            }, receiveValue: { _ in
                // The receiveValue will not be called in this case, as the createList function returns Void.
            })
            .store(in: &subscriptions)
    }

    
}
