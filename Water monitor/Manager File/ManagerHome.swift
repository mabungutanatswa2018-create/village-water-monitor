//
//  ManagerHome.swift
//  Water monitor
//
//  Created by Tana on 25/3/2026.
//


import SwiftUI
import SwiftData

struct ManagerHomeView: View {
    @Query(sort: \HouseHold.litersUsed, order: .reverse)
    var households: [HouseHold]

    var body: some View {
        
            ZStack {
                //background
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.9),
                        Color.cyan.opacity(0.85),
                        Color.indigo.opacity(0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Manager Dashboard")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("View and compare household water usage.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 8)

                    // List card
                    ZStack {
                        Color(.systemBackground)
                            .opacity(0.98)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                        if households.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.title)
                                    .foregroundColor(.orange)
                                Text("No households yet")
                                    .font(.headline)
                                Text("Ask households to create their accounts to see data here.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                            }
                            .padding()
                        } else {
                            //household list names
                            List {
                                Section(header: Text("Households (highest usage first)")) {
                                    ForEach(households) { household in
                                        HStack(spacing: 12) {
                                            // Leading icon + name
                                            VStack(alignment: .leading, spacing: 4) {
                                                HStack {
                                                    Image(systemName: "house.fill")
                                                        .foregroundColor(.blue)
                                                    Text(household.name)
                                                        .font(.headline)
                                                }

                                                Text("Total usage")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }

                                            Spacer()

                                            // Liters used
                                            Text("\(Int(household.litersUsed)) L")
                                                .font(.headline)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.vertical, 6)
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)

                    Spacer()
                }
            }
        }
    }


#Preview {
    ManagerHomeView()
}
