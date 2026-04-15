//
//  Welcome.swift
//  Water monitor
//
//  Created by Tana on 27/3/2026.
//


import SwiftUI

struct WelcomeView: View {
    @StateObject private var auth = Auth()
    var body: some View {
        NavigationStack {
            Group{
                if auth.isAuthenticated {
                    ManagerHomeView()
                } else {
                    //the welcome page
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color.cyan.opacity(0.5),
                                Color.blue.opacity(0.9)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                      
                        VStack(spacing: 28) {
                            Spacer().frame(height: 30)
                            
                            // Top welcome text
                            VStack(spacing: 8) {
                                Text("Welcome to")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                
                                Text("AquaTrack")
                                    .font(.system(size: 42, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            // Logo bubble
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 260, height: 260)
                                    .blur(radius: 1)
                                
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 190, height: 190)
                                    .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: 6)
                            }
                            .padding(.top, 8)
                            
                            // Tagline card
                            VStack(spacing: 10) {
                                Text("Make every drop count")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Monitor your household’s water usage, cut down on waste,\nand move towards a sustainable lifestyle.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .background(
                                Color(.systemBackground)
                                    .opacity(0.97)
                                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            )
                            .padding(.horizontal)
                            
                            Spacer()
                            
                            // Get started button
                            NavigationLink {
                                RoleSelection()
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "drop.fill")
                                        .font(.headline)
                                    Text("Get Started")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 46)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        colors: [Color.blue, Color.cyan],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 4)
                            }
                            .padding(.bottom, 34)
                        }
                        .padding()
                    }}
            }
        }
        .environmentObject(auth)
        .task {
            await auth.getInitialSession()
        }
    }
}
#Preview {
    WelcomeView()
}
