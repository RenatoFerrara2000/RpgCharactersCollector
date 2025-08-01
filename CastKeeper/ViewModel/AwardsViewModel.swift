//
//  AwardsViewModel.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 16/07/25.
//

import SwiftUI
import SwiftData
extension AwardsView {
    /**
     ## Overview

     Observable view model for the AwardsView that manages award state, determines unlock status based on database criteria, and provides formatted display properties.

     ## AwardsViewModel

     State management class for award system functionality.

     ## Properties

     ### State Properties
     - `selectedAward` - Currently selected award (defaults to example)
     - `showingAwardDetails` - Controls award detail alert presentation
     - `allAwards` - Complete list of available awards
     - `modelContext` - SwiftData context for database queries

     ## Core Methods

     ### isAwardEarned(_ award: Award) -> Bool
     Determines if award criteria are met based on database counts:

     **Supported Criteria:**
     - `"character"` - Counts Character entities against `award.value`
     - `"traits"` - Counts Traits entities against `award.value`
     - **Default:** Returns `false` for unknown criteria

     **Implementation:** Uses `FetchDescriptor` and `fetchCount()` for efficient counting.

     ### Display Formatting Methods

     #### awardTitle(for award: Award) -> String
     Returns localized title based on unlock status:
     - **Unlocked:** "Unlocked: [Award Name]" (localized format)
     - **Locked:** "Locked" (localized string)

     #### awardColor(for award: Award) -> Color
     Provides visual feedback through color coding:
     - **Unlocked:** `Color(award.color)` - Award's designated color
     - **Locked:** `.secondary.opacity(0.5)` - Dimmed appearance

     #### accessibilityLabel(for award: Award) -> String
     Generates accessibility-friendly labels:
     - **Unlocked:** "Unlocked: [Award Name]"
     - **Locked:** "Locked"

     ### selectAward(_ award: Award)
     Handles award selection and detail presentation:
     1. Sets `selectedAward` to chosen award
     2. Triggers `showingAwardDetails` for alert display

     */
    @Observable
    class AwardsViewModel {
        var selectedAward = Award.example
        var showingAwardDetails = false
        var allAwards = Award.allAwards
        
        var modelContext: ModelContext?
        
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
