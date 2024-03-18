//
//  CsToggleRectangleButton.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import SwiftUI

struct CsToggleRectangleButton: View {
    @State var isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            isActive.toggle()
            onTap()
        }) {
            HStack {
                Text("Mark as \(isActive ? "Undone" : "Done")")
                    .bold()
                Image(systemName: isActive ? "x.circle.fill" : "checkmark.circle.fill")
                    .bold()
            }
            .frame(height: 40)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .background(isActive ? Color.accentColor : Color.clear)
            .foregroundColor(isActive ? .white : .accentColor)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.blue, lineWidth: 1)
            )
        }
    }
}

struct CsToggleRectangleButton_Previews: PreviewProvider {
    @State static var isActive = false
    
    static var previews: some View {
        VStack {
            CsToggleRectangleButton(isActive: isActive) {
                print("Toggled status!")
            }
        }
        .padding(15)
    }
}
