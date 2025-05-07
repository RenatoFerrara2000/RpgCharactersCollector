//
//  DetailView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/04/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel
    @Binding  var selectedFilter: Filter?
    @Query var characterModels: [CharacterModel]

    var filteredCharacters: [CharacterModel] {
        if let filterTrait = selectedFilter?.trait {
            return characterModels.filter { character in
                // Only check for traits if traitsList exists
                guard let traits = character.traitsList else {
                    return false
                }
                return traits.contains(filterTrait)
            }
        } else {
            return characterModels
        }
    }
    
    var body: some View {
        ForEach(filteredCharacters) { characterModel in
            VStack {
                Text(characterModel.name)
                Text(characterModel.characterDescription)
            }
        }
    }
}

 
