import SwiftUI

struct LocalizationView: View {
    @StateObject private var viewModel = LocalizationViewModel()
    
    var body: some View {
        Form {
            Section {
                Button {
                    viewModel.copyResourcesFolderToClipboard()
                } label: {
                    Label("`Resources`", systemImage: "folder.badge.plus")
                }
                Button {
                    viewModel.copyLprojFolderToClipboard()
                } label: {
                    Label("`en.lproj`", systemImage: "folder.badge.plus")
                }
                Button {
                    viewModel.copyDefaultToClipboard()
                } label: {
                    Label("Set default localization", systemImage: "viewfinder.trianglebadge.exclamationmark")
                }
            } header: {
                Text("Define the folders")
            } footer: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create a **Resources** folder at the same level where Package.swift is located.")
                    Text("Inside, add language-specific `lproj` folders (like ‘en’, ‘es’, ‘jp’; two-letter ISO code) for each language.")
                    Text("Don't forget to set your package default localization!")
                }
            }
            
            Section {
                Button {
                    viewModel.copyStringsToClipboard()
                } label: {
                    Label("`Localizable.strings`", systemImage: "doc.badge.plus")
                }
                Button {
                    viewModel.copyStringsExampleToClipboard()
                } label: {
                    Label("Copy strings example", systemImage: "ellipsis.curlybraces")
                }
            } header: {
                Text("Strings")
            } footer: {
                Text("Provide key-value pairs for each language. Here's an example of how to write this kind of files.")
            }
            
            Section {
                Button {
                     viewModel.copyStringsdictToClipboard()
                } label: {
                    Label("`Localizable.stringsdict`", systemImage: "doc.badge.plus")
                }
            } header: {
                Text("Pluralization")
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Pluralization key")
                        .font(.caption)
                    TextField("messages",
                              text: $viewModel.pluralizationKey)
                    .textInputAutocapitalization(.never)
                }
                VStack(alignment: .leading) {
                    Text("Zero")
                        .font(.caption)
                    TextField("No messages.",
                              text: $viewModel.pluralZero)
                    .textInputAutocapitalization(.never)
                }
                VStack(alignment: .leading) {
                    Text("One")
                        .font(.caption)
                    TextField("One message.",
                              text: $viewModel.pluralOne)
                    .textInputAutocapitalization(.never)
                }
                VStack(alignment: .leading) {
                    Text("Two")
                        .font(.caption)
                    TextField("Two messages.",
                              text: $viewModel.pluralTwo)
                    .textInputAutocapitalization(.never)
                }
                VStack(alignment: .leading) {
                    Text("Few")
                        .font(.caption)
                    TextField("A few messages.",
                              text: $viewModel.pluralFew)
                    .textInputAutocapitalization(.never)
                }
                VStack(alignment: .leading) {
                    Text("Many")
                        .font(.caption)
                    TextField("Many messages.",
                              text: $viewModel.pluralMany)
                    .textInputAutocapitalization(.never)
                }
                VStack(alignment: .leading) {
                    Text("Other")
                        .font(.caption)
                    TextField("%d messages.",
                              text: $viewModel.pluralOther)
                    .textInputAutocapitalization(.never)
                }
            } footer: {
                HStack(alignment: .top) {
                    Image(systemName: "exclamationmark.bubble")
                        .font(.headline)
                    Text("Pluralization values depend on each language's rules and they are optional. Fill in only what's necessary for your language, leaving the others empty.")
                }
            }
            
            Section {
                Button {
                    viewModel.copyPluralizedContentToClipboard()
                } label: {
                    Label("Copy pluralized content", systemImage: "ellipsis.curlybraces")
                }
            }
        }
        .navigationBarTitle("Localize my app", displayMode: .inline)
    }
}

#Preview("Localization") {
    NavigationStack {
        LocalizationView()
    }
}
