//
//  CsTextField.swift
//  Blinterns ToDoList
//
//  Created by Calvin Anacia Suciawan on 21-02-2024.
//

import SwiftUI

struct CsTextField: View {
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let bgColor: Color? = nil
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.tertiary.opacity(0.3))
            .cornerRadius(5)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

struct CsTextField_Previews: PreviewProvider {
    @State static var text = ""
    
    static var previews: some View {
        CsTextField(text: $text, placeholder: "Username", keyboardType: .default)
    }
}
