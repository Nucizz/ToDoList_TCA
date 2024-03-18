//
//  CsRectangleButton.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 04-03-2024.
//

import SwiftUI

struct CsRectangleButton: View {
    let title: String
    let bgColor: Color
    let onTap: (() -> Void)
    
    init(title: String, bgColor: Color = .blue, onTap: @escaping (() -> Void)) {
        self.title = title
        self.bgColor = bgColor
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .bold()
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(bgColor)
                .cornerRadius(5)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 50) {
        CsRectangleButton(title: "Login") {
            debugPrint("Login Tapped")
        }
        CsRectangleButton(title: "Logout", bgColor: Color.red) {
            debugPrint("Logout Tapped")
        }
    }
    .padding(15)
}
