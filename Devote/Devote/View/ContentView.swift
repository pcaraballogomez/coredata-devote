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
    @AppStorage("isDarkMode") private var isDarkMode = true

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
                    HStack(spacing: 10) {
                        // Title
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)

                        Spacer()

                        // Edit button
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule()
                                    .stroke(Color.white, lineWidth: 2)
                            )

                        // Appearance button
                        Button {
                            isDarkMode.toggle()
                        } label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }
                    } //: HStack
                    .padding()
                    .foregroundColor(.white)

//                    if !items.isEmpty {
                        Spacer(minLength: 80)
//                    }

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
                                ListRowItemView(item: item)
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
            .navigationBarTitle("Daily Task", displayMode: .large)
            .navigationBarHidden(true)
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
