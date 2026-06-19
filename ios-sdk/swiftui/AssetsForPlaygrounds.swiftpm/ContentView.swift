import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(sections) { section in
                        NavigationLink(destination: section.destination) {
                            MenuItemView(text: section.text,
                                         icon: section.icon,
                                         color: section.color)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: BookView()) {
                        MenuItemView(text: "Playground Book",
                                     icon: "book.fill",
                                     color: .brown)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("Assets")
            
            EmptyContentView()
        }
        .listStyle(.sidebar)
    }
}

#Preview("Assets List View") {
    ContentView()
        .preferredColorScheme(.none)
}
