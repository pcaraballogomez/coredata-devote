//
//  ContentView.swift
//  Devote
//
//  Created by Pablo Caraballo Gómez on 31/1/24.
//

import SwiftUI
import CoreData

struct ContentView: View {

    // MARK: - Properties
    @State var task: String = ""

    private var isButtonDisabled: Bool {
        task.isEmpty
    }

    // MARK: - Fetching data
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 16.0) {
                        TextField("New Tast", text: $task)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(10)

                        Button {
                            addItem()
                        } label: {
                            Spacer()
                            Text("Save".uppercased())
                            Spacer()
                        }
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? .gray.opacity(0.8) : .pink)
                        .cornerRadius(10)
                        .disabled(isButtonDisabled)
                    } //: VStack
                    .padding()

                    if !items.isEmpty {
                        List {
                            ForEach(items) { item in
                                if let task = item.task {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(task)
                                            .font(.headline)
                                            .fontWeight(.bold)

                                        if let timestamp = item.timestamp {
                                            Text("At \(timestamp, formatter: itemFormatter)")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    } //: VStack
                                }
                            } //: ForEach
                            .onDelete(perform: deleteItems)
                        } //: List
                        .scrollContentBackground(.hidden)
                        .shadow(color: .black.opacity(0.3),
                                radius: 12)
                        .padding(.vertical, 0)
                        .frame(maxWidth: 640)
                        .background(Color.clear)
                    } else {
                        // FIXME: Workaround background
                        Spacer()
                    }
                } //: VStack
            } //: ZStack
            .navigationBarTitle("Daily Task",
                                displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            } //: Toolbar
            .background(
                BackgroundImageView()
            )
            .background(
                backgroundGradient.ignoresSafeArea()
            )
        } //: Navigation
        .navigationViewStyle(.stack)
    }

    // MARK: - Functions

    private func addItem() {
        defer {
            task = ""
            hideKeyboard()
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
