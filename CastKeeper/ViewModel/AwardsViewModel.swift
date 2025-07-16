//
//  AwardsViewModel.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 16/07/25.
//

import SwiftUI
import SwiftData

extension AwardsView {
    
    @Observable
    class ViewModel {
        
        var selectedAward: Award = Award.example
        var showingAwardDetails = false
        var allAwards = Award.allAwards
        
        var modelContext: ModelContext? = nil
        
        func isAwardEarned(_ award: Award) -> Bool {
            switch award.criterion {
            case "character":
                // returns true if they added a certain number of issues
                let descriptor = FetchDescriptor<Character>()
                let awardCount = (try? modelContext?.fetchCount(descriptor)) ?? 0
                return awardCount >= award.value
                
            case "traits":
                // return true if they created a certain number of tags
                let descriptor = FetchDescriptor<Traits>()
                let awardCount = (try? modelContext?.fetchCount(descriptor)) ?? 0
                return awardCount >= award.value
                
            default:
                // an unknown award criterion; this should never be allowed
                // fatalError("Unknown award criterion: \(award.criterion)")
                return false
            }
        }
        
        func awardTitle(for award: Award) -> String {
            if isAwardEarned(award) {
                let format = NSLocalizedString("Unlocked: %@", comment: "Award unlocked title")
                return String(format: format, award.name)
            } else {
                return NSLocalizedString("Locked", comment: "Award locked title")
            }
        }
        
        func awardColor(for award: Award) -> Color {
            return isAwardEarned(award) ? Color(award.color) : .secondary.opacity(0.5)
        }
        
        func accessibilityLabel(for award: Award) -> String {
            return isAwardEarned(award) ? "Unlocked: \(award.name)" : "Locked"
        }
        
        func selectAward(_ award: Award) {
            selectedAward = award
            showingAwardDetails = true
        }
    }
    
}
