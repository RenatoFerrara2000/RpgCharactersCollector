//
//  DetailView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            
            if let  selectedCharacter = viewModel.selectedCharacter {
                CharacterView(character: selectedCharacter)
            } else {
                NoCharacterView()
            }
        }
            .navigationTitle("Detail View")
            .navigationBarTitleDisplayMode(.inline)

    }
 }
    
#Preview {
    DetailView()
}

 
