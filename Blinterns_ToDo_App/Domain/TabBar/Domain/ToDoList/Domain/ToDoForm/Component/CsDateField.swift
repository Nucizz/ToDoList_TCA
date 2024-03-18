//
//  CsDateField.swift
//  Blinterns_ToDo_App
//
//  Created by Calvin Anacia Suciawan on 03-03-2024.
//

import SwiftUI

struct CsDateField: View {
    @Binding var datetime: Date
    @Binding var isActive: Bool
    let title: String
    
    var body: some View {
        HStack {
            DatePicker(selection: $datetime) {
                Text(title)
                    .foregroundColor(.gray)
            }
            .disabled(!isActive)

            Toggle(isOn: $isActive) {
                
            }
            .toggleStyle(CustomCheckbox())
        }
    }
}

struct CsDateField_Previews: PreviewProvider {
    @State static var datetime = Date.now
    @State static var isActive = false
    
    static var previews: some View {
        CsDateField(datetime: $datetime, isActive: $isActive, title: "Deadline")
    }
}

