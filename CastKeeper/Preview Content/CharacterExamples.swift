//
//  CharacterSamples.swift
//  CastKeeper
//
//  Created by Renato Ferrara on 16/07/25.
//

import Foundation

extension Character {
    static var exampleCharacters: [Character] {
        [
        Character(name: "Aria Storm", characterDescription: "A fearless sky pirate with a mysterious past.", role: "Protagonist", characterTraits: [Traits(name: "Lucky"), Traits(name: "Good Looking"), Traits(name: "Fearless")]),
        Character(name: "Draven Kael", characterDescription: "A brooding bounty hunter with a grudge.", role: "Antihero"),
        Character(name: "Selene Voss", characterDescription: "A cunning alchemist with a knack for poison.", role: "Villain"),
        Character(name: "Bryn Ember", characterDescription: "A cheerful blacksmith who dreams of adventure.", role: "Sidekick"),
        Character(name: "Orin Thorne", characterDescription: "An exiled prince turned reluctant hero.", role: "Protagonist"),
        Character(name: "Kaida Rune", characterDescription: "A dragon whisperer with ties to ancient magic.", role: "Mentor"),
        Character(name: "Talia Graves", characterDescription: "A ruthless general seeking revenge.", role: "Antagonist", characterTraits: [Traits(name: "Vengeful"), Traits(name: "Angry")])]
    }
}
