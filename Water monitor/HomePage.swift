//
//  HomePage.swift
//  Water monitor
//
//  Created by Tana on 16/10/2025.
//

import SwiftUI

struct HomePage: View {
    @State private var names = ["Rhodes", "Miller", "Willing", "Harrison","Johnson", "Smith", "Moyo", "Ncube", "Hill", "Wilson", "Shumba", "Ndlovu", "Warner", "Ewart", "Brown", "White", "Jones", "Washington", "Phiri", "Patil"]
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
                
                List{ ForEach(names, id: \.self){name in
                   
                   NavigationLink(destination: Details()) {
                    Text(name)
                    }
                        
                }
                
                .onDelete(perform: deleteName)
                
                }
                if showTextField {
                    HStack {
                        TextField("Enter family name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.leading)
                        
                        Button(action:{
                            if !newName.isEmpty {
                                names.append(newName)
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
        func deleteName(at offsets: IndexSet){
            names.remove(atOffsets: offsets)
        }
    
}
#Preview {
    HomePage()
}
