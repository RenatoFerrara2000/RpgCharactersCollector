//
//  TraitsMenuView.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 18/07/25.
//
import SwiftUI

/**
 ## Overview

 SwiftUI menu component that provides filtering and sorting controls for character management, featuring toggle-based filter control and sorting options.

 ## TraitsMenuView

 Dropdown menu for filter and sort configuration.


 ## Architecture

 ### State Management
 - `@Environment(ViewModel.self)` - Shared app state
 - `@Bindable var viewModel` - Enables two-way binding to viewModel properties

 ### Menu Structure
 1. **Filter toggle** - Enable/disable filtering
 2. **Divider** - Visual separation
 3. **Sort submenu** - Sorting configuration options

 ## Menu Options

 ### Filter Control
 - **Dynamic button text** based on `viewModel.filterEnabled` state
 - **Toggle action** switches filtering on/off
 - **Visual feedback** through symbol variants (filled when enabled)

 ### Sort By Options
 **Picker selection** bound to `viewModel.sortType`:
 - `SortType.dateCreated` - Sort by creation date
 - `SortType.dateModified` - Sort by modification date

 ### Sort Order Options
 **Picker selection** bound to `viewModel.sortNewestFirst`:
 - `true` - Newest to Oldest
 - `false` - Oldest to Newest

 ## Menu Label
 - **Label:**  "Filter" with decrease circle icon
 - **Symbol variant:**  Filled when filter enabled, outline when disabled
 - **Visual state indicator**  shows current filter status
 */
struct TraitsMenuView: View {
    @Environment(ViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        Menu {
            Button(viewModel.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                viewModel.filterEnabled.toggle()
            }
            
            Divider()
            
            Menu("Sort By") {
                Picker("Sort By", selection: $viewModel.sortType) {
                    Text("Date Created").tag(SortType.dateCreated)
                    Text("Date Modified").tag(SortType.dateModified)
                }
                
                Divider()
                
                Picker("Sort Order", selection: $viewModel.sortNewestFirst) {
                    Text("Newest to Oldest").tag(true)
                    Text("Oldest to Newest").tag(false)
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            .symbolVariant(viewModel.filterEnabled ? .fill : .none)
        }.accessibilityIdentifier("Filter-Button")
    }
}

#Preview {
    TraitsMenuView()
    .environment(ViewModel())}
