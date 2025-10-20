//
//  ContentView.swift
//  Water monitor
//
//  Created by Tana on 16/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 400, height: 400)
                Text("AquaTrack")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Monitor  usage, reduce waste and enjoy a more sustainable lifestyle!")
                Spacer()
                NavigationLink("Get started"){HomePage()
                    
                }
                .padding()
                .foregroundStyle(.black)
                .fontWeight(.bold)
                .background(Capsule().fill(Color.blue))
            }
        }
    }
}

#Preview {
    ContentView()
}
