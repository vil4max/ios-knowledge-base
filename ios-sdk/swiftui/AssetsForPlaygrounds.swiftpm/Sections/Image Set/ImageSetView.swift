import SwiftUI

struct ImageSetView: View {
    @StateObject private var viewModel = ImageSetViewModel()
    
    var body: some View {
        Form {
            Section {
                TextField("Name this image",
                          text: $viewModel.imageName)
                .textInputAutocapitalization(.never)
                
                if viewModel.imageType != .symbol &&
                    viewModel.imageType != .appicon {
                    Toggle("Template Image",
                           isOn: $viewModel.isTemplate.animation())
                    Toggle("Adaptive Image",
                           isOn: $viewModel.isAdaptive.animation())
                }
            } header: {
                Text("Define an Image")
            } footer: {
                viewModel.footerAdaptive
            }
            
            Section {
                Picker("Image format", selection: $viewModel.imageType.animation()) {
                    ForEach(ImageSetBuilder.ImageType.allCases) { option in
                        Text(option.rawValue.uppercased())
                            .tag(option)
                    }
                }
            } footer: {
                viewModel.footerType
            }
            
            Section {
                Button {
                    viewModel.copyImageSetToClipboard()
                } label: {
                    if viewModel.imageName.isEmpty {
                        Label("Unnamed image",
                              systemImage: "folder.badge.plus")
                    } else {
                        Label("`\(viewModel.imageName).\(viewModel.imageType.folderExtension)`",
                              systemImage: "folder.badge.plus")
                    }
                }
                
                Button {
                    viewModel.copyContentsToClipboard()
                } label: {
                    Label("`Contents.json`",
                          systemImage: "doc.badge.plus")
                }
                
                Button {
                    viewModel.copyImageToClipboard()
                } label: {
                    Label("Copy JSON content",
                          systemImage: "ellipsis.curlybraces")
                }
                
                Label(viewModel.placeCopy,
                      systemImage: "doc.on.doc")
            } header: {
                Text("Add Image to the Project")
            } footer: {
                Text("Place the new asset into the **Assets.xcassets** folder.")
            }
            .disabled(viewModel.imageName.isEmpty ? true : false)
        }
        .navigationBarTitle("New image asset", displayMode: .inline)
    }
}

#Preview("ImageSet") {
    NavigationStack {
        ImageSetView()
    }
}
