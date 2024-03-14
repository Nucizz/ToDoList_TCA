//
//  CsTextEditor.swift
//  Blinterns ToDoList
//
//  Created by Calvin Anacia Suciawan on 21-02-2024.
//

import SwiftUI

struct CsTextEditor: View {
    @Binding var text: String
    let placeholder: String
    
    @State private var localText: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .foregroundColor(.gray.opacity(0.5))
            }
            TextEditor(text: $localText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding(.horizontal, 10)
                .padding(.vertical, 1)
                .frame(height: 150)
                .scrollContentBackground(.hidden)
                .onChange(of: text) { newText in
                    localText = newText
                }
                .onChange(of: localText) { newLocalText in
                    text = newLocalText
                }

        }
        .background(.tertiary.opacity(0.3))
        .cornerRadius(5)
        .onAppear {
            localText = text
        }
    }
}

struct CsTextEditor_Previews: PreviewProvider {
    @State static var text = ""
    
    static var previews: some View {
        CsTextEditor(text: $text, placeholder: "Description")
    }
}

