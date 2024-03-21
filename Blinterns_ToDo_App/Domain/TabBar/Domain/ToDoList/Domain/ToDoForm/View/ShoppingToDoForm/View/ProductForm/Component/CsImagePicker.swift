//
//  CsImagePicker.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import SwiftUI
import PhotosUI

struct CsImagePicker: View {
    @Binding var selectedImage: UIImage?
    @State var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        GeometryReader { geometry in
            PhotosPicker(selection: $photosPickerItem) {
                Image(uiImage: (selectedImage ?? UIImage(named: "Set an Image")!))
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                    .cornerRadius(5)
            }
            .onChange(of: photosPickerItem) {
                Task {
                    if let photosPickerItem,
                       let data = try await photosPickerItem.loadTransferable(type: Data.self),
                       let image = ImageScaler().process(
                        imageAt: data,
                        to: geometry.size
                       ) {
                        selectedImage = image
                    }
                    photosPickerItem = nil
                }
            }
        }
        .frame(maxHeight: 180)
    }
}

struct CsImagePicker_Previews: PreviewProvider {
    @State static var image: UIImage?
    
    static var previews: some View {
        CsImagePicker(selectedImage: $image)
    }
}
