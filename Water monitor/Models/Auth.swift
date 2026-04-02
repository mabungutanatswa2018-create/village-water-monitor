//
//  Auth.swift
//  Water monitor
//
//  Created by Tana on 27/3/2026.
//

import Supabase
import SwiftUI
import Combine

@MainActor
class Auth: ObservableObject {
    @Published var session: Session?
    @Published var isAuthenticated: Bool = false
    
    func getInitialSession() async {
        do{
            let current = try await supabase.auth.session
            self.session = current
            self.isAuthenticated = current != nil
        }catch{
            print("No active session \(error.localizedDescription)")
        }
        
    }
    
    func signUp(email: String, password: String) async {
        do {
            let result = try await supabase.auth.signUp(email: email, password: password)
            self.session = result.session
            self.isAuthenticated = self.session != nil
        } catch {
         
            print("Sign up failed: \(error.localizedDescription)")
            
        }
    }
    
    func signIn(email: String, password: String) async  {
        do {
            let result = try await supabase.auth.signIn(email: email, password: password)
            self.session = result
            self.isAuthenticated = self.session != nil
        } catch {
         
            print("Sign in failed: \(error.localizedDescription)")
            
        }
    }
    
    func signOut(email: String, password: String) async {
        do {
            try await supabase.auth.signOut()
            self.session = nil
            self.isAuthenticated = false
        }
        catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }
    
}


