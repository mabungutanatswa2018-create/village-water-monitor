//
//  HomePage.swift
//  Water monitor
//
//  Created by Tana on 16/10/2025.
//
import SwiftUI
import SwiftData

struct HomePage: View {
    @Environment(\.modelContext) private var context
    @Query var households: [HouseHold]

    @State private var selectedHousehold: HouseHold?
    @State private var showPasswordSheet = false
    @State private var isUnlocked = false
    @State private var averageUsage: Double = 150

    @State private var newName: String = ""
    @State private var newPassword: String = ""
    @State private var showTextField: Bool = false

    var body: some View {
        NavigationStack {
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

                VStack {
                    // Header 
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Households")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Select your household to log.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .horizontal])

                    // Card around your existing List + add form
                    ZStack {
                        Color(.systemBackground)
                            .opacity(0.98)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                        VStack(spacing: 0) {
                         //household list names
                            List {
                                ForEach(households) { household in
                                    Button {
                                        selectedHousehold = household
                                        isUnlocked = false
                                        showPasswordSheet = true     // ask password on tap
                                    } label: {
                                        HStack {
                                            Image(systemName: "house.fill")
                                                .foregroundColor(.blue)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(household.name)
                                                    .font(.headline)
                                                
                                                if let manager = household.manager {
                                                    Text(manager.name)            // community / admin name
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                            }
                                                Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.black)
                                                .font(.caption)
                                    
                                    }

                                        .padding(.vertical, 4)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .onDelete(perform: deleteHouseholds)
                            }
                            .scrollContentBackground(.hidden)
                           
                            //textfield for name and password
                            if showTextField {
                                Divider()
                                    .padding(.horizontal)

                                VStack(spacing: 8) {
                                    Text("Add a new household")
                                        .font(.subheadline.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal)

                                    TextField("Family name", text: $newName)
                                        .textFieldStyle(.roundedBorder)
                                        .padding(.horizontal)

                                    SecureField("Set password", text: $newPassword)
                                        .textFieldStyle(.roundedBorder)
                                        .padding(.horizontal)

                                    Button("Add Household") {
                                        guard !newName.isEmpty, !newPassword.isEmpty else { return }

                                        let newHousehold = HouseHold(
                                            name: newName,
                                            password: newPassword,
                                            sourceID: UUID().uuidString,
                                            litersUsed: 0,
                                            refills: []
                                        )
                                        context.insert(newHousehold)
                                        try? context.save()

                                        newName = ""
                                        newPassword = ""
                                        showTextField = false
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .padding(.bottom, 8)
                                }
                                .padding(.top, 8)
                            }
                        }
                    }
                    .padding(.horizontal)

                   //show textfield
                    Button {
                        withAnimation {
                            showTextField.toggle()
                        }
                    } label: {
                        Image(systemName: showTextField ? "xmark.circle.fill" : "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 3)
                    }
                    .padding(.top, 8)
                    .padding(.bottom)
                    Text("Add household") // or "Add household" / "Add reading"
                                .foregroundColor(.white)
                                .font(.headline)
                }
            }
          // navigation and sheet logic
            .navigationTitle("Households")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isUnlocked) {
                if let household = selectedHousehold {
                    DetailView(
                        household: household,
                        averageUsage: $averageUsage
                    )
                }
            }
            .sheet(isPresented: $showPasswordSheet) {
                if let household = selectedHousehold {
                    PasswordGateView(
                        household: household,
                        onSuccess: {
                            showPasswordSheet = false
                            isUnlocked = true        // go to DetailView
                        },
                        onCancel: {
                            showPasswordSheet = false
                        }
                    )
                }
            }
        }
    }

    private func deleteHouseholds(at offsets: IndexSet) {
        for index in offsets {
            let household = households[index]
            context.delete(household)
        }
        try? context.save()
    }
}



// Password screen shown AFTER tapping the name
struct PasswordGateView: View {
    let household: HouseHold
    let onSuccess: () -> Void
    let onCancel: () -> Void

    @State private var enteredPassword: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                // Match other screens with gradient
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
                    Spacer().frame(height: 20)

                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)

                        Text("Enter password")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Text(household.name)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }

                    // Card around your original content
                    VStack(spacing: 16) {
                        // === Your original fields and buttons (logic unchanged) ===
                        SecureField("Password", text: $enteredPassword)
                            .textFieldStyle(.roundedBorder)

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button("Continue") {
                            checkPassword()
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Cancel") {
                            onCancel()
                        }
                        .buttonStyle(.bordered)
                        // === End original logic ===
                    }
                    .padding()
                    .background(
                        Color(.systemBackground)
                            .opacity(0.98)
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    )
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
        }
    }

    private func checkPassword() {
        if enteredPassword == household.password {
            errorMessage = ""
            onSuccess()
        } else {
            errorMessage = "Wrong password. Please try again."
        }
    }
}



#Preview {
    HomePage()
        .modelContainer(for: HouseHold.self, inMemory: true)
        
}
