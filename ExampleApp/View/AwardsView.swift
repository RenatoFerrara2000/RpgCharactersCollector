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
        if hasEarned(award: selectedAward) {
            return "Unlocked: \(selectedAward.name)"
        } else {
            return "Locked"
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
                                 .foregroundColor(hasEarned(award: award) ? Color(award.color) : .secondary.opacity(0.5))

                        }
                    }
                }
            }
            .navigationTitle("Awards")
            
        }.alert(awardTitle, isPresented: $showingAwardDetails) {
        } message: {
            Text(selectedAward.description)
        }
    }
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "character":
            // returns true if they added a certain number of issues
            let descriptor = FetchDescriptor<Character>()
            let awardCount = (try? modelContext.fetchCount(descriptor)) ?? 0
            return awardCount >= award.value

        case "traits":
            // return true if they created a certain number of tags
            let descriptor = FetchDescriptor<Traits>()
            let awardCount = (try? modelContext.fetchCount(descriptor)) ?? 0
            return awardCount >= award.value

        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}

#Preview {
    AwardsView()
    
}
