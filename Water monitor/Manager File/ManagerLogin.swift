//
//  Untitled.swift
//  Water monitor
//
//  Created by Tana on 25/3/2026.
//


import SwiftUI

import Combine

struct ManagerLoginView: View {
    @EnvironmentObject var auth : Auth
    @Environment(\.modelContext) private var context
    //@Query var managers: [Manager]
    
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var signUpMessage: String = ""
 
    @State private var showSignUp = false
    var onLoginSuccess: () -> Void 
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
                
                VStack(spacing: 28) {
                    Spacer().frame(height: 20)
                    
                    VStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.white)
                        
                        Text("Manager Login")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Log in with your community manager account.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textFieldStyle(.roundedBorder)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                        
                        if !signUpMessage.isEmpty {
                            Text(signUpMessage)
                                .foregroundColor(.green)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        //log in button
                        Button {
                            Task {
                                await auth.signIn(email: email, password: password)
                                
                                if auth.isAuthenticated {
                                    onLoginSuccess()
                                } else {
                                    errorMessage = "Login failed"
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Log In")
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
                        //creat new manager button
                        Button {
                            showSignUp = true
                        } label: {
                            Text("Create a new manager account")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
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
           //sheet that shows the sign up view
            .sheet(isPresented: $showSignUp) {
                ManagerSignUpView() { newEmail in
                    email = newEmail
                    password = ""
                    signUpMessage = "Account created. Please log in."
                    errorMessage = ""
                }
                .environmentObject(auth)
            }
        }
    
    
//    private func login() {
//        let typedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        let typedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        if let _ = managers.first(where: {
//            $0.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == typedEmail &&
//            $0.password.trimmingCharacters(in: .whitespacesAndNewlines) == typedPassword
//        }) {
//            errorMessage = ""
//            signUpMessage = ""
//           
//        } else {
//            errorMessage = "Email or password is incorrect."
//        }
//    }
}
#Preview {
    ManagerLoginView(onLoginSuccess: {})
        .environmentObject(Auth())
}
