//
//  NoCharacterView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 07/05/25.
//

import SwiftUI
struct NoCharacterView: View {
    @Environment(\.modelContext) var modelContext
 
    var body: some View {
        VStack {
            Text("No character selected")
                .font(.title)
            
            NavigationLink(destination: {
                let newChar = Character(name: "New Character", characterDescription: "", role: "")
                modelContext.insert(newChar)
                return CharacterView(character: newChar)
            }()) {
                Text("New Character")
                    .padding()
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
    }
}
#Preview {
    NoCharacterView()
 }
