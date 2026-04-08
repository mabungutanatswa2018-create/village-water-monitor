//
//  ContentView.swift
//  Water monitor
//
//  Created by Tana on 16/10/2025.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var auth = Auth()
    var body: some View {
            Group {
                if auth.isAuthenticated {
                    ManagerHomeView()
                } else {
                    ManagerLoginView( onLoginSuccess: {})
                        .environmentObject(auth)
                }
            }
            .task {
                await auth.getInitialSession()
            }
            .environmentObject(auth)
        }
    }


