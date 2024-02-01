//
//  ListRowItemView.swift
//  Devote
//
//  Created by Pablo Caraballo Gómez on 1/2/24.
//

import SwiftUI

struct ListRowItemView: View {

    // MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: Item

    // MARK: - Body
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? .pink : .primary)
                .padding(.vertical, 12)
                .animation(.default, value: item.task)
        } //: Toggle
        .toggleStyle(CheckBoxStyle())
        .onReceive(item.objectWillChange) { _ in
            if viewContext.hasChanges {
                try? viewContext.save()
            }
        }
    }
}
