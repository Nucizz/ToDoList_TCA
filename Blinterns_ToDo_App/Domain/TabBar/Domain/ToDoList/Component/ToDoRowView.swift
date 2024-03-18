//
//  ToDoListRowView.swift
//  Blinterns ToDoList
//
//  Created by Calvin Anacia Suciawan on 21-02-2024.
//

import SwiftUI
import ComposableArchitecture

struct ToDoListCardView: View {
    @State var toDo: AnyToDoModel
    let onChecked: (_ updatedToDo: AnyToDoModel) -> Void
    let onTapped: () -> Void
    
    func getTitleColor() -> Color {
        if let deadlineTime = toDo.deadlineTime,
           deadlineTime <= Date.now && !toDo.isFinished {
            return .red
        }
        return .primary
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Toggle(isOn: $toDo.isFinished) {
                //MARK: Empty component to reduce touch area
            }
            .toggleStyle(CustomCheckbox())
            .onChange(of: toDo.isFinished) { 
                onChecked(toDo)
                toDo.isFinished.toggle()
            }
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(toDo.title)
                        .lineLimit(1)
                        .font(.title3)
                        .bold()
                        .foregroundColor(getTitleColor())
                    Spacer()
                    Text(toDo.category.rawValue)
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 5)
                        .background(toDo.category.color)
                        .cornerRadius(5)
                }
                if let description = toDo.description {
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 5)
            .contentShape(Rectangle())
            .onTapGesture {
                onTapped()
            }
            
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        
    }
}
