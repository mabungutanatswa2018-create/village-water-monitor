//
//  Details.swift
//  Water monitor
//
//  Created by Tana on 20/10/2025.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    let household: HouseHold
    @Environment(\.modelContext) private var context
    @Binding var averageUsage: Double
    
    //convert the new refill to an int for liters
   private var litersUsedIntBinding: Binding<Int> {
        Binding(
            get: { Int(household.litersUsed.rounded()) },
            set: { newValue in household.litersUsed = Double(newValue) }
        )
    }
    
    private var refillsBinding: Binding<[Refill]> {
        Binding(
            get: { household.refills },
            set: { newValue in
                household.refills = newValue
            }
        )
    }
    

    var body: some View {
        ZStack {
            // Background
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
            
            VStack(spacing: 24) {
              
                Spacer()
                // Household title area
                VStack(spacing: 6) {
                    Text(household.name)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Household water usage overview")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal)
               
                // Stats card
                VStack(spacing: 14) {
                    // Liters used
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Liters Used")
                                .font(.headline)
                            Text("Total water used so far")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(Int(household.litersUsed)) L")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(
                                colorForUsage(
                                    liters: household.litersUsed,
                                    average: averageUsage
                                )
                            )
                    }
                    .padding()
                    .background(
                        colorForUsage(
                            liters: household.litersUsed,
                            average: averageUsage
                        ).opacity(0.20)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    
                    // Refills
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Refills")
                                .font(.headline)
                            Text("How many times you refilled")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(household.refills.count)")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.20))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    
                    // Average usage
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Average Usage")
                                .font(.headline)
                            Text("Target for similar households")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(Int(averageUsage)) L")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding()
                .background(
                    Color(.systemBackground)
                        .opacity(0.98)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                )
                .padding(.horizontal)
                
                Spacer()
                
               
                NavigationLink(
                    destination: RefillPageView(
                        householdName: household.name,
                        refills: refillsBinding,
                        litersUsed: litersUsedIntBinding
                    )
                ) {
                    HStack(spacing: 8) {
                        Image(systemName: "drop.fill")
                        Text("View / Add Refills")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [Color.white, Color.cyan.opacity(0.9)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 3)
                    .padding(.horizontal)
                }
                
                Spacer().frame(height: 16)
            }
        }
        .navigationTitle("Household Details")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            do {
                try context.save()
            } catch {
                print("Failed to save household details:", error)
            }
        }
    }
}


#Preview {
    NavigationStack {
        DetailView(
            household: HouseHold(name: "Moyo", password: "1234", sourceID: "Borehole A", litersUsed: 180),
            averageUsage: .constant(150)
        )
    }
}
