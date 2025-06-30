//
//  DetailView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import SwiftUI
import SwiftData

 struct DetailView: View {
    var selectedCharacter: Character?
    
    var body: some View {
        VStack {
            if let character = selectedCharacter {
                CharacterView(character: character)
            } else {
                NoCharacterView()
            }
        }
        .navigationTitle("Detail View")
        .navigationBarTitleDisplayMode(.inline)
    }
}

    
#Preview {
    DetailView(selectedCharacter: Character.example)
 }

 
