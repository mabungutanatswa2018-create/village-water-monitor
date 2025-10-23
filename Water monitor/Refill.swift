//
//  Refill.swift
//  Water monitor
//
//  Created by Tana on 20/10/2025.
//


import SwiftUI

struct RefillPageView: View {
    var householdName: String
    @Environment(\.dismiss) var dismiss
    @State private var refills: [Refill] = []
    @State private var newRefillAmount: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Refills for \(householdName)")
                .font(.title)
                .bold()
                .padding(.top)
            
            // List of past refills
            List(refills) { refill in
                HStack {
                    Text(refill.date, style: .date)
                    Spacer()
                    Text("\(refill.amount, specifier: "%.1f") L")
                        .bold()
                }
            }
            .buttonStyle(.borderedProminent)
                        .tint(.blue)

            Divider()
            
            // Add new refill
            VStack(spacing: 10) {
                TextField("Enter liters refilled", text: $newRefillAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding(.horizontal)
                
                Button("Add Refill") {
                    if let amount = Double(newRefillAmount), amount > 0 {
                        refills.append(Refill(amount: amount, date: Date()))
                        newRefillAmount = ""
                        dismiss() // 👈 goes back automatically
                    }
                }
                
                
            }
            
            Spacer()
            
        }
        .navigationTitle("Refill Log")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //  Add a new refill
    func addRefill() {
        if let amount = Double(newRefillAmount), amount > 0 {
            let newRefill = Refill(amount: amount, date: Date())
            refills.append(newRefill)
            newRefillAmount = ""
        }
    }
}

//  Refill model
struct Refill: Identifiable {
    let id = UUID()
    let amount: Double
    let date: Date
}

#Preview {
    NavigationView {
        RefillPageView(householdName: "Moyo")
    }
}
