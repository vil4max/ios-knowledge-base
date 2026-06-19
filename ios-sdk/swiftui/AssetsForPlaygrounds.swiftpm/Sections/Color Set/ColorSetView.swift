import SwiftUI

struct ColorSetView: View {
    @StateObject private var viewModel = ColorSetViewModel()
    
    var body: some View {
        Form {
            Section {
                TextField("Name this color", text: $viewModel.colorName)
                    .textInputAutocapitalization(.never)
                
                Toggle("Adaptive Color", isOn: $viewModel.isAdaptive.animation())
            } header: {
                Text("Define a Color")
            }
            
            Section {
                ColorPicker(viewModel.isAdaptive ? "Light Appearance" : "Color", selection: $viewModel.lightColor)
                
                if viewModel.isAdaptive {
                    ColorPicker("Dark Appearance", selection: $viewModel.darkColor)
                }
            }
            .transition(.opacity)
            
            Section {
                Button {
                    viewModel.copyColorSetToClipboard()
                } label: {
                    if viewModel.colorName.isEmpty {
                        Label("Unnamed color", systemImage: "folder.badge.plus")
                    } else {
                        Label("`\(viewModel.colorName).colorset`", systemImage: "folder.badge.plus")
                    }
                }
                
                Button {
                    viewModel.copyContentsToClipboard()
                } label: {
                    Label("`Contents.json`", systemImage: "doc.badge.plus")
                }
                
                Button {
                    viewModel.copyColorToClipboard()
                } label: {
                    Label("Copy ColorSet content", systemImage: "ellipsis.curlybraces")
                }
            } header: {
                Text("Add Color to the Project")
            } footer: {
                Text("Place the color set into the **Assets.xcassets** folder.")
            }
            .disabled(viewModel.colorName.isEmpty ? true : false)
        }
        .navigationBarTitle("New color set", displayMode: .inline)
    }
}

#Preview("ColorSet") {
    NavigationStack {
        ColorSetView()
    }
}
