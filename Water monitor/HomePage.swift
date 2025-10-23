//
//  HomePage.swift
//  Water monitor
//
//  Created by Tana on 16/10/2025.
//

import SwiftUI

struct Household: Identifiable {
    let id = UUID()
    var name: String
    var litersUsed: Double
    var refillCount: Int
    var averageUsage: Double
}

class HouseholdViewModel: ObservableObject {
    @Published var litersUsed: Double = 0
    @Published var refillCount: Int = 0
    @Published var refills: [Refill] = []
}


struct HomePage: View {
//    @Binding var selectedTab: Int
    @State private var names = [
        Household(name: "Rhodes", litersUsed: 120, refillCount: 2, averageUsage: 150),
        Household(name: "Miller", litersUsed: 180, refillCount: 3, averageUsage: 150),
        Household(name: "Waner", litersUsed: 90, refillCount: 1, averageUsage: 150),
        Household(name: "Ewart", litersUsed: 40, refillCount: 4, averageUsage: 150),
        Household(name: "Ncube", litersUsed: 200, refillCount: 5, averageUsage: 150)
    ]

    @State var newName: String = ""
    @State private var showTextField = false
    var body: some View {
        NavigationStack{
            VStack {
                
                HStack {
                    Text("Family names")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                    
                }
                .padding(.trailing, 20)
                List {
                    ForEach($names) { $name in
                        NavigationLink(destination: HouseholdDetailView(
                            householdName: name.name,
                            litersUsed: $name.litersUsed,
                            refillCount: $name.refillCount,
                            averageUsage: $name.averageUsage
                        )) {
                            Text(name.name)
                        }
                    }
                    .onDelete(perform: deleteHousehold)
                }
                if showTextField {
                    HStack {
                        TextField("Enter family name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                        
                        Button(action:{
                            if !newName.isEmpty {
                                let newHousehold = Household(
                                    name: newName,
                                    litersUsed: 0,
                                    refillCount: 0,
                                    averageUsage: 150
                                )
                                names.append(newHousehold)
                                newName = ""
                                showTextField.toggle()
                            }

                            
                        }){
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(.horizontal)
                }
                
                //animation of a button and plus button
                Button(action:{
                    withAnimation{
                        showTextField.toggle()
                    }
                    
                }){
                    Image(systemName: showTextField ? "xmark.circle.fill" : "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .padding()
                    
                }
                
                
            }
        }
    }
    //deleting a name
    func deleteHousehold(at offsets: IndexSet) {
        names.remove(atOffsets: offsets)
    }
}
    

#Preview {
    HomePage()
}
