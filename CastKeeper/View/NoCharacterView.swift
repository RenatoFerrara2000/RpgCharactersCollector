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
        Text("No character selected")
            .font(.title)
        
        Button("Add Character") {
         
        }
        Button("New Character") {
            modelContext.insert(Character(name: "New Character", characterDescription: "", role: ""))
        }

    }
}

#Preview {
    NoCharacterView()
        .environment(ViewModel())
}
