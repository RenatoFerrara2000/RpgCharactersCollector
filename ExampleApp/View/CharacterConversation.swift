//
//  CharacterConversation.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//
import SwiftUI

struct CharacterConversation: View {
    @State private var client = ApiClient(apiKey: "You wish")
    
    var character: Character

    @State private var messages = [Message]()
    @State private var messageText =  ""

    var body: some View {
        Section("Chat") {
                        VStack(spacing: 0) {
                            List(messages) { message in
                                HStack {
                                    if message.isAI {
                                        Image(systemName: "figure.fencing")
                                            .foregroundColor(.blue)
                                    } else {
                                        Image(systemName: "person")
                                            .foregroundColor(.green)
                                    }
                                    Text(message.text)
                                        .padding(.leading, 8)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                            .frame(minHeight: 200)
                            
                            HStack {
                                TextField("Write Something", text: $messageText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onSubmit(sendMessage)
                                
                                Button("Send", action: sendMessage)
                                    .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                            .padding()
                        }
                    }
    }
    
    func sendMessage(){
        let prompt = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard prompt.isEmpty == false else {return}
        
        messageText = ""
        
        withAnimation {
            messages.append(Message(text: prompt, isAI: false))
        }
        Task {
            let lastAiMessage = messages.last(where: \.isAI)
            let response = try await client.generateText(
                              from: prompt,
                              instructions: buildCharacterInstructions(),
                              conversationHistory: messages.dropLast() // Exclude the message we just added
                          )
 
        let newMessage = Message(id: response.id, text: response.message, isAI: true)
        
        withAnimation {
            messages.append(newMessage)
        }
        }
    }
    
    private func buildCharacterInstructions() -> String {
            var instructions = """
            You are roleplaying as a character named "\(character.name.isEmpty ? "Unknown Character" : character.name)".
            
            Character Details:
            - Name: \(character.name.isEmpty ? "Unknown" : character.name)
            - Role: \(character.role.isEmpty ? "No specific role" : character.role)
            - Description: \(character.characterDescription.isEmpty ? "No description provided" : character.characterDescription)
            """
            
            // Add traits if they exist
            if let traits = character.traitsList, !traits.isEmpty {
                let traitNames = traits.compactMap { $0.name }.joined(separator: ", ")
                instructions += "\n- Key Traits: \(traitNames)"
            }
            
            instructions += """
            
            
            IMPORTANT GUIDELINES:
            - Stay in character at all times
            - Respond as this character would, based on their description, role, and traits
            - Keep responses conversational and engaging
            - You may be addressing minors, so never use or tolerate offensive language
            - If asked about your identity, you are this character, not an AI
            - Draw from the character's background to inform your responses
            """
            
            return instructions
        }
}

#Preview {
    CharacterConversation(character: .example)
}
