//
//  SidebarViewModel.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 17/07/25.
//
import SwiftUI
/**
 # SidebarViewModel Documentation

 ## Overview

 Observable view model for SidebarView that manages filter selection, trait renaming operations, and modal presentation states.

 ## SidebarViewModel

 State management class for sidebar functionality.

 ## Properties

 ### Selection State
 - `selectedFilter: Filter?` - Currently selected filter option

 ### Rename Operation State
 - `tagToRename: Traits?` - Trait being renamed
 - `newTagName: String` - New name input text
 - `isRenamingTag: Bool` - Controls rename alert presentation

 ### Modal State
 - `showingAwards: Bool` - Controls awards sheet presentation

 ## Methods

 ### getTraitsFilter(from traits: [Traits]) -> [Filter]
 Transforms traits array into filter objects:

 1. **Groups traits by name** using Dictionary grouping
 2. **Sorts alphabetically** by trait name
 3. **Maps to Filter objects** with:
    - ID from first trait in group
    - Trait name as filter name
    - "tag" system icon
    - Reference to first trait instance

 ### renameTrait(_ trait: Traits)
 Initiates trait renaming process:
 1. Sets `tagToRename` to target trait
 2. Pre-populates `newTagName` with current name
 3. Triggers `isRenamingTag` for alert presentation

 ### completeRename(traits: [Traits])
 Completes trait renaming operation:

 **Validation:**
 - Guards against missing `tagToRename`
 - Checks for name conflicts (TODO: Error handling needed)

 **Execution:**
 - Updates all traits with matching old name
 - Applies `newTagName` to all instances

 ## Data Flow

 ### Rename Workflow
 1. User selects "Rename" from context menu
 2. `renameTrait()` sets up rename state
 3. Alert presents with text field bound to `newTagName`
 4. User confirms, triggering `completeRename()`
 5. All matching traits updated with new name
 */
extension SidebarView {
    @Observable
    class SidebarViewModel {
        var selectedFilter: Filter?
        var tagToRename: Traits?
        var newTagName: String = ""
        var isRenamingTag: Bool = false
        var showingAwards = false
        
        func getTraitsFilter(from traits: [Traits]) -> [Filter] {
            let grouped = Dictionary(grouping: traits) { $0.name }
            let sortedGrouped = grouped.sorted { $0.key < $1.key }
            return sortedGrouped.map { name, traits in
                Filter(id: traits.first!.id, name: name, icon: "tag", trait: traits.first!)
            }
        }
        
        func renameTrait(_ trait: Traits) {
            tagToRename = trait
            newTagName = trait.name
            isRenamingTag = true
        }
        
        func completeRename(traits: [Traits]) {
            guard let oldName = tagToRename?.name else { return }
            
            if traits.contains(where: { $0.name == newTagName }) {
                // TODO: Error handling
                return
            }
            
            for trait in traits where trait.name == oldName {
                trait.name = newTagName
            }
        }
    }
}
