//
//  Details.swift
//  Water monitor
//
//  Created by Tana on 20/10/2025.
//

import SwiftUI



class HouseViewModel: ObservableObject {
    @Published var litersUsed: Double = 0
    @Published var refillCount: Int = 0
    @Published var refills: [Refill] = []
}


struct HouseholdDetailView: View {
    var householdName: String
    @Binding var litersUsed: Double
    @Binding var refillCount: Int
    @Binding var averageUsage: Double
    
    var body: some View {
        VStack(spacing: 20) {
            Text(householdName)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            VStack(spacing: 15) {
                MetricView(title: "Liters Used", value: litersUsed, color: colorForUsage(liters: litersUsed, average: averageUsage))
                MetricView(title: "Refills", value: Double(refillCount), color: .blue)
                MetricView(title: "Average Usage", value: averageUsage, color: .gray)
            }
            .padding()
            
            NavigationLink(destination: RefillPageView(householdName: householdName)) {
                Text("View/Add Refills")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationTitle("Household Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // Simple color function 
    func colorForUsage(liters: Double, average: Double) -> Color {
        if liters > average + 20 {
            return .red
        } else if liters > average {
            return .yellow
        } else {
            return .green
        }
    }
}

struct MetricView: View {
    var title: String
    var value: Double
    var color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text("\(value, specifier: "%.1f")")
                .bold()
        }
        .padding()
        .background(color.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationView {
        HouseholdDetailView(
            householdName: "Moyo",
            litersUsed: .constant(180),
            refillCount: .constant(3),
            averageUsage: .constant(150)
        )
    }
}
