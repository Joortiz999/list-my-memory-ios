//
//  LocalizableStrings.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import Foundation
import SwiftUI

typealias Common = LocalizedTags.Common
typealias Alerts = LocalizedTags.Alerts
typealias Registration = LocalizedTags.Registration
typealias Login = LocalizedTags.Login
typealias Splash = LocalizedTags.Splash
typealias Events = LocalizedTags.Events
typealias Lists = LocalizedTags.Tasks
typealias Profile = LocalizedTags.Profile
typealias Settings = LocalizedTags.Settings

struct LocalizedTags{
    struct URL {
        static let Web: LocalizedStringKey = "label.webpage"
    }
    struct Connection {
        static let ConnectionErrorTitle: LocalizedStringKey = "error.connection.title"
        static let ConnectionErrorMessage: LocalizedStringKey = "error.connection.message"
    }
    struct Feature {
        static let FeatureErrorTitle: LocalizedStringKey = "feature.not.available.title"
        static let FeatureErrorMessage: LocalizedStringKey = "feature.not.available.message"
    }
    struct Common {
        static let Hello: LocalizedStringKey = "label.hello"
        static let Loading: LocalizedStringKey = "label.loading"
        static let NotFound: LocalizedStringKey = "label.notFound"
        static let OK: LocalizedStringKey = "label.ok"
        static let Information: LocalizedStringKey = "label.information"
        static let More: LocalizedStringKey = "label.more"
        static let All: LocalizedStringKey = "label.all"
        static let About: LocalizedStringKey = "label.about"
        static let Conditions: LocalizedStringKey = "label.contitions"
        static let Version: LocalizedStringKey = "label.version"
        
    }
    struct Buttons {
        static let Continue: LocalizedStringKey = "button.continue"
        static let Cancel: LocalizedStringKey = "button.cancel"
        static let Accept: LocalizedStringKey = "button.accept"
        static let Decline: LocalizedStringKey = "button.decline"
        static let Close: LocalizedStringKey = "button.close"
        static let Select: LocalizedStringKey = "button.select"
        static let Open: LocalizedStringKey = "button.open"
        static let Retry: LocalizedStringKey = "button.retry"
        static let TryAgain: LocalizedStringKey = "button.tryAgain"
        static let Login: LocalizedStringKey = "button.login"
        static let LogOut: LocalizedStringKey = "button.logout"
        static let Back: LocalizedStringKey = "button.back"
        static let SaveChanges: LocalizedStringKey = "button.saveChanges"
        static let Options: LocalizedStringKey = "button.options"
        static let MoreOptions: LocalizedStringKey = "button.more.options"
    }
    struct Splash {
        
    }
    struct Registration {
        static let Title: LocalizedStringKey = "label.registration.title"
        static let FirstName: LocalizedStringKey = "label.first.name"
        static let LastName: LocalizedStringKey = "label.last.name"
        static let Occupation: LocalizedStringKey = "label.occupation"
    }
    struct Login {
        static let Email: LocalizedStringKey = "label.email"
        static let Password: LocalizedStringKey = "label.password"
        static let LogIn: LocalizedStringKey = "label.login"
        static let Register: LocalizedStringKey = "label.register"
        static let ForgotPassword: LocalizedStringKey = "label.forgot.password"
    }
    struct Alerts {
        
    }
    struct Events {
        static let NewEvents: LocalizedStringKey = "label.events.new.events"
        static let UpcommingEvents: LocalizedStringKey = "label.events.upcomming.events"
        static let EventSuggestions: LocalizedStringKey = "label.event.suggestions"
        static let TodaysEvents: LocalizedStringKey = "label.event.todays"
        static let EventLocation: LocalizedStringKey = "label.event.location"
        static let WeeklyEvents: LocalizedStringKey = "label.event.weekly"
    }
    struct Tasks {
        static let AddNewTask: LocalizedStringKey = "label.task.add.new"
        static let WeeklyTask: LocalizedStringKey = "label.task.weekly"
    }
    struct Profile {
        
    }
    struct Settings{
        
    }
}
