//
//  NoCharacterView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 07/05/25.
//

import SwiftUI

struct NoCharacterView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            Text("No character selected")
                .font(.title)
            
            Button("New Character") {
                let char = Character(name: "New Character", characterDescription: "", role: "")
                modelContext.insert(char)
                
                // Set the newly created character as selected
                viewModel.selectedCharacter = char
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
#Preview {
    NoCharacterView()
}
