//
//  CharacterConversation.swift
//  ExampleApp
//
//  Created by Renato Ferrara on 30/06/25.
//
import SwiftUI

struct CharacterConversation: View {
    @State private var viewModel = ViewModel()
    var character: Character
 
    var body: some View {
        Section("Chat") {
            VStack(spacing: 0) {
                List(viewModel.messages) { message in
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
                    TextField("Write Something", text: $viewModel.messageText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            viewModel.sendChatMessage(char: character)
                        }
                    
                    Button{
                        viewModel.sendChatMessage(char: character)

                    } label: {
                        Text("Send")
                    }
                    .disabled(viewModel.canSendMessage)
                }
                .padding()
            }
        }
    }
}

#Preview {
    CharacterConversation(character: .exampleCharacters[0])
}
