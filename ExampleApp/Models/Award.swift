//
//  Award.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 16/05/25.
//
import Foundation
import SwiftData

struct Award: Decodable, Identifiable {
    var id: String { name }
    var name: String
    var description: String
    var color: String    
    var criterion: String
    var value: Int
    var image: String

    static let allAwards = Bundle.main.decode("Awards.json", as: [Award].self)
    static let example = allAwards[0]
    
    func hasEarned(modelContext: ModelContext) -> Bool {
        switch criterion {
        case "character":
            // returns true if they added a certain number of issues
            let descriptor = FetchDescriptor<Character>()
            let awardCount = (try? modelContext.fetchCount(descriptor)) ?? 0
            return awardCount >= value

        case "traits":
            // return true if they created a certain number of tags
            let descriptor = FetchDescriptor<Traits>()
            let awardCount = (try? modelContext.fetchCount(descriptor)) ?? 0
            return awardCount >= value

        default:
            // an unknown award criterion; this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
    
    
}
