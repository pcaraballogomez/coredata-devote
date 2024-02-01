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
    @State private var showNewTaskItem = false

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
                // MARK: - Main View
                VStack {
                    // MARK: - Header
                    Spacer(minLength: 80)

                    // MARK: - New task button
                    Button {
                        showNewTaskItem = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        backgroundGradient
                            .clipShape(Capsule())
                    )
                    .shadow(color: .black.opacity(0.25),
                            radius: 8,
                            x: .zero,
                            y: 4.0)

                    // MARK: - Tasks
                    if items.isEmpty {
                        Spacer() // FIXME: Workaround background
                    } else {
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
                    }
                } //: VStack

                // MARK: - New task item

                if showNewTaskItem {
                    BlankView()
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
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
