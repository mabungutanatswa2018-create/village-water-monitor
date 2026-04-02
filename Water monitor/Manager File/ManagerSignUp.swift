//
//  ManagerSignUp.swift
//  Water monitor
//
//  Created by Tana on 26/3/2026.
//

import SwiftUI
import SwiftData

struct ManagerSignUpView: View {
    @EnvironmentObject var auth: Auth
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var onSignUp: (String) -> Void   // callback to login

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
   // @State private var showPassword: Bool = false
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        
            ZStack {
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
                    Spacer().frame(height: 20)

                    VStack(spacing: 8) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.white)

                        Text("Create Manager Account")
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        Text("Each community admin can have their own login.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    VStack(spacing: 14) {
                        TextField("Name (community or admin)", text: $name)
                            .textFieldStyle(.roundedBorder)

                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textFieldStyle(.roundedBorder)

                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)

                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(.roundedBorder)

                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        //sign up button
                        Button {
                            Task {
                                    await auth.signUp(email: email, password: password)

                                    if auth.isAuthenticated {
                                        onSignUp(email)
                                        dismiss()         // close sheet
                                    } else {
                                        errorMessage = "Sign up failed"
                                    }
                                }
                        } label: {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Create Account")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        }
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
            .navigationTitle("New Manager")
            .navigationBarTitleDisplayMode(.inline)
        }
    
    //checks if all fileds are filled, create the manager and saves
    private func createManager() {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }

        let manager = Manager(
                name: name,
                email: email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                password: password.trimmingCharacters(in: .whitespacesAndNewlines)
            )

            context.insert(manager)
        do {
            try context.save()
            print("saved manager:", manager.email)
            onSignUp(email)   // tell login which email
            dismiss()
        } catch {
            errorMessage = "Failed to save manager."
            print("Error saving manager:", error)
        }
    }
}


#Preview {
    ManagerSignUpView() { _ in }
        .modelContainer(for: Manager.self, inMemory: true)
        .environmentObject(Auth())
}
