//
//  OverlayVStack.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI

struct OverlayVStack<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        content()
                    }
                    .frame(width: geometry.size.width * 0.75)
                    .padding(15)
                    .background(Color(.systemBackground))
                    .cornerRadius(5)
                    
                    Spacer()
                }
                .frame(height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(Color.black.opacity(0.5))
        .ignoresSafeArea()
    }
}


#Preview {
    OverlayVStack {
        Text("Hello World")
    }
}
