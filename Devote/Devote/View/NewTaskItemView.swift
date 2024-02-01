//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Pablo Caraballo Gómez on 1/2/24.
//

import SwiftUI

struct NewTaskItemView: View {

    // MARK: - Properties
    @State var task: String = ""
    @Binding var isShowing: Bool
    @AppStorage("isDarkMode") private var isDarkMode = true

    private var isButtonDisabled: Bool {
        task.isEmpty
    }

    // MARK: - Fetching data
    @Environment(\.managedObjectContext) private var viewContext

    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 16.0) {
                TextField("New Tast", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        Color(isDarkMode ? .tertiarySystemBackground : .secondarySystemBackground)
                    )
                    .cornerRadius(10)

                Button {
                    addItem()
                } label: {
                    Spacer()
                    Text("Save".uppercased())
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }
                .padding()
                .foregroundColor(.white)
                .background(isButtonDisabled ? .blue.opacity(0.5) : .pink)
                .cornerRadius(10)
                .disabled(isButtonDisabled)
            } //: VStack
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                Color(isDarkMode ? .secondarySystemBackground : .white)
            )
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.65),
                    radius: 24)
            .frame(maxWidth: 640)
        } //: VStack
        .padding()
    }

    // MARK: - Functions
    private func addItem() {
        defer {
            task = ""
            hideKeyboard()
            isShowing = false
        }
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Preview
struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(
                Color.gray.edgesIgnoringSafeArea(.all)
            )
    }
}
