//
//  DestinationRowView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 06-03-2024.
//

import SwiftUI

struct DestinationRowView: View {
    let destination: Destination
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .frame(width: 5, height: 5)
                .padding(.top, 12.5)
            VStack(alignment: .leading) {
                Text(destination.name)
                    .font(.title2)
                    .bold()
                    .lineLimit(1)
                
                if let address = destination.address {
                    Text(address)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if let latitude = destination.latitude, let longitude = destination.longitude {
                if let url = URL(string: "http://maps.apple.com/?daddr=\(latitude),\(longitude)&dirflg=d&t=h") {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 15) {
            ForEach(1...15, id: \.self) { index in
                DestinationRowView(destination:
                    Destination(
                        name: "Blibli.com Head Office",
                        address: "Gedung Sarana Jaya, Gambir, Jakarta Pusat, DKI Jakarta, Indonesia"
                    )
                )
            }
        }
    }
    .padding(.horizontal, 15)
}
