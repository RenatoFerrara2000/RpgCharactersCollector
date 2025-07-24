//
//  SidebarViewModel.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 17/07/25.
//
import SwiftUI

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
