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
        PhotosPicker(selection: $photosPickerItem) {
            Image(uiImage: (selectedImage ?? UIImage(named: "Set an Image"))!)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 180)
                .cornerRadius(5)
        }
        .onChange(of: photosPickerItem) {
            Task {
                if let photosPickerItem {
                    let data = try await photosPickerItem.loadTransferable(type: Data.self)
                    if let image = UIImage(data: data!) {
                        selectedImage = image
                    }
                }
                photosPickerItem = nil
            }
        }
    }
}

struct CsImagePicker_Previews: PreviewProvider {
    @State static var image: UIImage?
    
    static var previews: some View {
        CsImagePicker(selectedImage: $image)
    }
}
