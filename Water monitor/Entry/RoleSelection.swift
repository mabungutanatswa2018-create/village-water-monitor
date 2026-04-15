//
//  RoleSelection.swift
//  Water monitor
//
//  Created by Tana on 26/3/2026.
//

import SwiftUI

struct RoleSelection: View {
    @State private var showManagerLogin = false
    @State private var managerLoggedIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.9),
                        Color.cyan.opacity(0.8),
                        Color.indigo.opacity(0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    Spacer().frame(height: 10)

                    // Logo + Title
                    VStack(spacing: 12) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .shadow(radius: 12)

                        Text("AquaTrack")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)

                        Text("Track water usage. Save water. Live sustainably.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Card with role choices
                    VStack(spacing: 20) {
                        Text("Choose how you want to use the app")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.bottom, 4)

                        // Household button
                        NavigationLink {
                            HomePage()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "house.fill")
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Household Login")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text("View and track your own water usage.")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                        }

                        // Manager button that presents login sheet
                        Button(action: { showManagerLogin = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.badge.key.fill")
                                    .font(.title2)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Manager Login")
                                        .font(.headline)
                                    Text("Manage households and monitor usage across the network.")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: Color.black.opacity(0.10), radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding()
                    .background(
                        Color(.systemBackground)
                            .opacity(0.95)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    )
                    // manager login sheet
                    .sheet(isPresented: $showManagerLogin) {
                        ManagerLoginView() {
                            // called on successful login
                            showManagerLogin = false        // close login sheet
                            managerLoggedIn = true          // go to ManagerHomeView
                        }
                        .environmentObject(Auth())
                    }
                    .navigationDestination(isPresented: $managerLoggedIn) {
                        ManagerHomeView()
                    }
                    .padding(.horizontal)

                    Spacer()

                    
                    Text("Created with care to protect every drop.")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 8)
                }
                .padding()
            }
        }
    }
}

#Preview {
    RoleSelection()
}

