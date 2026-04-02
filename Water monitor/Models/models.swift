//
//  HoueseHold.swift
//  Water monitor
//
//  Created by Tana on 25/3/2026.
//

import SwiftUI
import SwiftData

//HOUSEHOLD
@Model
class HouseHold {
    var name: String
    var password: String
    var sourceID: String
    var litersUsed: Double
    var refills: [Refill]

    // NEW: which manager/community this household belongs to
    var manager: Manager?

    init(
        name: String,
        password: String,
        sourceID: String,
        litersUsed: Double = 0,
        refills: [Refill] = [],
        manager: Manager? = nil
    ) {
        self.name = name
        self.password = password
        self.sourceID = sourceID
        self.litersUsed = litersUsed
        self.refills = refills
        self.manager = manager
    }
}

//REFILL
@Model
class Refill {
    var amount: Double
    var date: Date

    init(amount: Double, date: Date = .now) {
        self.amount = amount
        self.date = date
    }
}

//COLOR
func colorForUsage(liters: Double, average: Double) -> Color {
    if liters > average + 40 {
        return .red
    } else if liters > average {
        return .yellow
    } else {
        return .green
    }
}

//MANAGERS
@Model
class Manager {
    var name: String
    var email: String
    var password: String

    @Relationship(deleteRule: .cascade)
    var households: [HouseHold] = []    // all households in this community

    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}



// Example details screen
struct HouseholdDetailView: View {
    let household: HouseHold

    var body: some View {
        VStack(spacing: 16) {
            Text("Details for \(household.name)")
                .font(.title)
            // your usage details go here
        }
        .padding()
    }
}


