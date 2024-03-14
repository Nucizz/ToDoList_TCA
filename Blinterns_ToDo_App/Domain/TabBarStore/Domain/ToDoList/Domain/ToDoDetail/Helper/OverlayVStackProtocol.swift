//
//  OverlayVStackProtocol.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI

protocol OverlayVStackable: View {
    associatedtype Content: View
        
    func overlayVStack<Content: View>(@ViewBuilder childView: @escaping () -> Content) -> Content
}

extension OverlayVStackable {
    func overlayVStack<Content: View>(@ViewBuilder childView: @escaping () -> Content) -> some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        childView()
                    }
                    .frame(width: geometry.size.width * 0.75)
                    .padding(15)
                    .background(.background)
                    .cornerRadius(5)
                    
                    Spacer()
                }
                .frame(height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .background(.black.opacity(0.5))
    }
}

struct ContentView: View, OverlayVStackable {
    typealias Content = View
    
    var body: some View {
        OverlayVStackable {
            Text("Hello World")
        }
    }
}
