//
//  Refill.swift
//  Water monitor
//
//  Created by Tana on 20/10/2025.
//


import SwiftUI
import SwiftData


struct RefillPageView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss    // <- add this

    var householdName: String
    @Binding var refills: [Refill]
    @State private var newRefillAmount: String = ""
    @Binding var litersUsed: Int
    
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
            //Heading
            VStack(spacing: 20) {
                Text("Refills for \(householdName)")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top)
                
                List(refills) { refill in
                    HStack {
                        Text(refill.date, style: .date)
                        Spacer()
                        Text("\(refill.amount, specifier: "%.1f") L")
                            .bold()
                            .foregroundColor(.blue)
                    }
                }
                .scrollContentBackground(.hidden)
                
                Divider()
                
                VStack(spacing: 10) {
                    TextField("Enter liters refilled", text: $newRefillAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)
                    
                    Button("Add Refill") {
                        if let amount = Double(newRefillAmount), amount > 0 {
                            let newRefill = Refill(amount: Double(Int(amount)), date: Date())
                            refills.append(newRefill)
                            litersUsed += Int(amount)
                            newRefillAmount = ""

                            do {
                                try context.save()
                            } catch {
                                print("Failed to save refills:", error)
                            }

                            // <- NEW: go back to DetailView after adding
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("Refill Log")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    struct PreviewHost: View {
        @State private var refills: [Refill] = [
            Refill(amount: 2.0, date: .now.addingTimeInterval(-3600)),
            Refill(amount: 1.5, date: .now.addingTimeInterval(-7200))
        ]
        @State private var litersUsed: Int = 0

        var body: some View {
            NavigationView {
                RefillPageView(
                    householdName: "Moyo",
                    refills: $refills,
                    litersUsed: $litersUsed
                )
            }
        }
    }

    return PreviewHost()
}
