//
//  SubjectRowView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 07-03-2024.
//

import SwiftUI

struct SubjectRowView: View {
    let subject: Subject
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .frame(width: 5, height: 5)
                .padding(.top, 12.5)
            VStack(alignment: .leading) {
                Text(subject.title)
                    .font(.title2)
                    .bold()
                    .lineLimit(1)
                
                if let sourceUrl = subject.sourceUrl, let url = URL(string: sourceUrl) {
                    Link(
                        destination: url
                    ) {
                        Text(sourceUrl)
                            .font(.callout)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .underline()
                    }
                }
                
                if let note = subject.note {
                    Text(note)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer()
        }        
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 15) {
            ForEach(1...15, id: \.self) { index in
                SubjectRowView(subject: Subject(title: "Hello", sourceUrl: "https://google.com"))
            }
        }
    }
    .padding(.horizontal, 15)
}
