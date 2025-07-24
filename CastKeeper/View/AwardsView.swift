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
    @State private var viewModel = AwardsViewModel()

    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.allAwards) { award in
                        Button {
                            viewModel.selectAward(award)
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(viewModel.awardColor(for: award))
                        }
                        .accessibilityLabel(
                            viewModel.accessibilityLabel(for: award)
                        )
                        .accessibilityHint(award.description)
                    }
                }
            }
            .navigationTitle("Awards")
        }
        .alert(
            viewModel.awardTitle(for: viewModel.selectedAward),
            isPresented: $viewModel.showingAwardDetails
        ) {
            // Empty action closure
        } message: {
            Text(viewModel.selectedAward.description)
        }
        .onAppear {
            viewModel.modelContext = modelContext
        }
    }
}

#Preview {
    AwardsView()
}
