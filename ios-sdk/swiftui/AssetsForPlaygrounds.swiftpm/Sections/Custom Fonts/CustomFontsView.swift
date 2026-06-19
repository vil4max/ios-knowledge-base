import SwiftUI

struct CustomFontsView: View {
    @StateObject private var viewModel = CustomFontsViewModel()
    
    var body: some View {
        Form {
            Section { 
                Label("Import custom font files from **Files app** or by **dragging** them into the app resources.", systemImage: "doc.badge.plus")
            } header: {
                Text("Step 1")
            }
            
            Section {
                Button {
                    viewModel.copyMyFontToClipboard()
                } label: {
                    Label("Copy Font extension", systemImage: "ellipsis.curlybraces")
                }
            } header: {
                Text("Step 2")
            } footer: {
                Text("Generate a `MyFont.swift` file within your project directory.")
            }
            
            Section {
                Label("Register fonts early in the app's startup routine.", systemImage: "app")
                
                Button {
                    viewModel.copyInitToClipboard()
                } label: {
                    Text("""
init() {
    MyFont.registerFonts()
}
""")
                        .font(.system(.footnote, design: .monospaced))
                }
            } header: {
                Text("Step 3")
            } footer: {
                Text("Embed this code snippet within the `@main` struct.")
            }
            
            Section {
                Label("Use it in your project!", systemImage: "textformat")
                Button {
                    viewModel.copyModifierUsageToClipboard()
                } label: {
                    Text("""
Text("Hello Playground!")
    .font(.custom("FONT-NAME", size: 16, relativeTo: .body))
""")
                        .font(.system(.footnote, design: .monospaced))
                }
            } header: {
                Text("Step 4")
            } footer: {
                Text("Ensure accessibility by honoring Dynamic Type settings. Use the `relativeTo` parameter to scale text appropriately, with reference styles like `.body`, `.headline`, etc.")
            }
        }
        .navigationBarTitle("Import custom fonts", displayMode: .inline)
    }
}

#Preview("Custom Fonts View") {
    NavigationStack {
        CustomFontsView()
    }
}
