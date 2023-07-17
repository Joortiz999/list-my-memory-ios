//
//  EventSuggestionView.swift
//  ListMyMemory
//
//  Created by JORGE ANDRES ORTIZ RODRIGUEZ on 14/7/23.
//

import SwiftUI

struct EventSuggestionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Event").font(.system(size: 26, design: .rounded).bold())
            Text("descripcion de evento").font(.system(size: 12, design: .rounded).italic())
            Text("Lugar").font(.callout.bold())
//            Text("").font(.caption.bold())
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red)
        .overlay(alignment: .topTrailing) {
            Button {
                //TODO: Handle Delete Event Logic
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .symbolVariant(.fill)
                    .foregroundColor(.white.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
    }
}

struct EventSuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        EventSuggestionView().preview(with: "Events dashboard")
    }
}
