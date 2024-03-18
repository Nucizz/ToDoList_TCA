//
//  ProductRowView.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 05-03-2024.
//

import SwiftUI
import Dependencies

struct ProductRowView: View {
    @Dependency(\.fileManagerRepository) var fileManagerRepository
    let product: Product
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            if let imageUrl = product.imagePath, let image = try? fileManagerRepository.loadImage(imageUrl) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
            } else {
                Image("Set an Image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
            }
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.title2)
                    .bold()
                    .lineLimit(1)
                
                if let productUrl = product.storeUrl, let url = URL(string: productUrl) {
                    Link(
                        destination: url
                    ) {
                        Text(productUrl)
                            .font(.callout)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .underline()
                    }
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 15) {
            ForEach(1...15, id: \.self) { index in
                ProductRowView(product:
                    Product(
                        name: "Macbook Pro M3",
                        storeUrl: "https://blibli.com/products/id?qwerty123uiop/qty?3/remark?jangan+di+bungkus+kayu"
                    )
                )
            }
        }
    }
    .padding(.horizontal, 15)
}
