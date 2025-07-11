//
//  CharacterConversation.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//
import SwiftUI

struct CharacterConversation: View {
    @State private var client = ApiClient(apiKey: "n...no")
    
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
                        .onSubmit(sendChatMessage)
                    
                    Button("Send", action: sendChatMessage)
                        .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
        }
    }
}


extension CharacterConversation {
    // P
    func sendChatMessage() {
        let prompt = messageText
        messageText = ""
        
        withAnimation {
            messages.append(Message(text: prompt, isAI: false))
        }
        
        Task {
            do {
                let response = try await client.sendMessage(prompt, messages: messages.dropLast(), instructions:  character.buildCharacterInstructions())
                withAnimation {
                    messages.append(response)
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CharacterConversation(character: .example)
}
