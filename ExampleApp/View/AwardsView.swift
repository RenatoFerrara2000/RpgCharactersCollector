//
//  AwardsView.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 16/05/25.
//

import SwiftUI
import SwiftData

struct AwardsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
    
    var awardTitle: String {
        if selectedAward.hasEarned( modelContext: modelContext){
            let format = NSLocalizedString("Unlocked: %@", comment: "Award unlocked title")
            return String(format: format, selectedAward.name)
        } else {
            return NSLocalizedString("Locked", comment: "Award locked title")
        }
    }

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails = true
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(award.hasEarned( modelContext: modelContext) ? Color(award.color) : .secondary.opacity(0.5))

                        }.accessibilityLabel(
                            award.hasEarned( modelContext: modelContext) ? "Unlocked: \(award.name)" : "Locked"
                        )
                        .accessibilityHint(award.description)
                    }
                }
            }
            .navigationTitle("Awards")
            
        }.alert(awardTitle, isPresented: $showingAwardDetails) {
        } message: {
            Text(selectedAward.description)
        }
    }
    
}

#Preview {
    AwardsView()
    
}
