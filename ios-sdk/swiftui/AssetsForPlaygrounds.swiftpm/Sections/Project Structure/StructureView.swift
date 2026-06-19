import SwiftUI

struct StructureView: View {
    @StateObject private var viewModel = StructureViewModel()
    
    var body: some View {
        Form {
            Section {
                Button {
                    viewModel.copyAssetsToClipboard()
                } label: {
                    Label("`Assets.xcassets`", systemImage: "folder.badge.plus")
                }
            } header: {
                Text("Step 1")
            } footer: {
                Text("You must create an **Assets** folder at the same level where Package.swift is located.")
            }
            
            Section {
                Button {
                    viewModel.copyContentsToClipboard()
                } label: {
                    Label("`Contents.json`", systemImage: "doc.badge.plus")
                }
                Button {
                    viewModel.copyJSONToClipboard()
                } label: {
                    Label("Copy JSON content", systemImage: "ellipsis.curlybraces")
                }
            } header: {
                Text("Step 2")
            } footer: {
                Text("Place this file at the root level of the **Assets.xcassets** folder.")
            }
            
            Section {
                Text("Another method to do this is to add a custom **App Icon** through the **App Settings** options.")
                    .font(.footnote)
            } header: {
                Text("In Swift Playground")
            }
        }
        .navigationBarTitle("Set up the project", displayMode: .inline)
    }
}

#Preview("Project Structure") {
    NavigationStack {
        StructureView()
    }
}
