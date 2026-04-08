//
//  Water_monitorApp.swift
//  Water monitor
//
//  Created by Tana on 16/10/2025.
//
import SwiftUI
import SwiftData

@main
struct Water_monitorApp: App {
    var body: some Scene {
        WindowGroup {
          WelcomeView()
               
        }
        .modelContainer(for: [HouseHold.self, Manager.self])
    }
}
