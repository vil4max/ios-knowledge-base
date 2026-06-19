import SwiftUI

struct BookView: View {
    @StateObject private var viewModel = BookViewModel()
    
    var body: some View {
        Form {
            Section {
                Button("Book.playgroundbook") {
                    viewModel.copyPlaygroundBookName()
                }
                .font(.footnote)
                .tint(.primary)
                
                DisclosureGroup("Contents", isExpanded: $viewModel.contentsGroup) {
                    Button("Manifest.plist") {
                        viewModel.copyBookManifest()
                    }
                    .tint(.primary)
                    DisclosureGroup("Chapters", isExpanded: $viewModel.chaptersGroup) {
                        DisclosureGroup("Chapter1.playgroundchapter", isExpanded: $viewModel.chapterItem) {
                            Button("Manifest.plist") {
                                viewModel.copyChapterManifest()
                            }
                            .tint(.primary)
                            DisclosureGroup("Pages", isExpanded: $viewModel.pagesGroup) {
                                DisclosureGroup("Page.playgroundpage", isExpanded: $viewModel.pageItem) {
                                    Button("Manifest.plist") {
                                        viewModel.copyPageManifest()
                                    }
                                    .tint(.primary)
                                    Button("main.swift") {
                                        viewModel.copyPageMain()
                                    }
                                    .tint(.primary)
                                    Button("LiveView.swift﹡") {
                                        viewModel.copyPageLiveView()
                                    }
                                    .tint(.primary)
                                }
                                Text("Other Page.playgroundpage")
                                DisclosureGroup("Template.playgroundpage", isExpanded: $viewModel.pageItemTemplate) {
                                    Text("Manifest.plist")
                                    Text("main.swift")
                                }
                            }
                        }
                        Text("Chapter2.playgroundchapter")
                        Text("Chapter3.playgroundchapter")
                    }
                }
                .font(.footnote)
            } header: {
                Text("Basic Structure")
            } footer: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Everything goes into `Contents` folder.")
                    Text("When we set `HasMeaningfulReset-Point` to true, this will enable us to delete the automatically generated `Edit` folder.")
                }
            }
            
            Section {
                List {
                    DisclosureGroup("Modules", isExpanded: $viewModel.modulesGroup) {
                        DisclosureGroup("ModuleName.playgroundmodule", isExpanded: $viewModel.moduleItem) {
                            DisclosureGroup("Sources", isExpanded: $viewModel.moduleSourcesItem) {
                                Button("HiddenLogic.swift") {
                                    viewModel.copyHiddenModule()
                                }
                                .tint(.primary)
                            }
                        }
                    }
                    DisclosureGroup("UserModules", isExpanded: $viewModel.userModulesGroup) {
                        DisclosureGroup("ModuleName.playgroundmodule", isExpanded: $viewModel.userModuleItem) {
                            DisclosureGroup("Sources", isExpanded: $viewModel.userModuleSourcesItem) {
                                Button("SharedCode.swift") {
                                    viewModel.copySharedModule()
                                }
                                .tint(.primary)
                            }
                        }
                    }
                }
                .font(.footnote)
            } header: {
                Text("Modules")
            } footer: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("You have to define the module mode: `Full`, `Limited` or `Disabled`.")
                    Text("These folders have to be saved into `Contents` folder.")
                }
            }
            
            Section {
                List {
                    Button("PrivateResources") {
                        viewModel.copyPrivateResources()
                    }
                    .tint(.primary)
                    Button("PublicResources") {
                        viewModel.copyPublicResources()
                    }
                    .tint(.primary)
                }
                .font(.footnote)
            } header: {
                Text("Resources")
            } footer: {
                Text("Visibility level of these resources depends on where you create each folder:\n`Book`, `Chapter` or `Page`")
            }
            
            Section {
                List {
                    DisclosureGroup("SwiftPage.cutscenepage", isExpanded: $viewModel.swiftCutscene) {
                        Button("Manifest.plist") {
                            viewModel.copyCutsceneSwiftManifest()
                        }
                        .tint(.primary)
                        Text("Cutscene.swift")
                    }
                    DisclosureGroup("HTMLPage.cutscenepage", isExpanded: $viewModel.htmlCutscene) {
                        Button("Manifest.plist") {
                            viewModel.copyCutsceneHTMLManifest()
                        }
                        .tint(.primary)
                        Text("PrivateResources")
                    }
                }
                .font(.footnote)
            } header: {
                Text("Cutscenes")
            } footer: {
                Text("Apple used to use [Hype](https://tumult.com/hype/) app to create `HTML` cutscenes. Now it's mostly Swift cutscenes.")
            }
            
            Section {
                List {
                    Button("Hints.plist") {
                        viewModel.copyHintsFile()
                    }
                    .tint(.primary)
                }
                .font(.footnote)
            } header: {
                Text("Hints")
            } footer: {
                Text("Hints are stored at `Page` level, and they have to be inside the `PrivateResources` folder.")
            }
            
            Section {
                List {
                    Link(destination: URL(string: "https://developer.apple.com/documentation/swift-playgrounds/playground-books")!, label: {
                        Label("Playground Books", systemImage: "link")
                    })
                    Link(destination: URL(string: "https://developer.apple.com/documentation/swift-playgrounds/structuring-content-for-swift-playgrounds")!, label: {
                        Label("Structuring Book Content", systemImage: "link")
                    })
                    Link(destination: URL(string: "https://developer.apple.com/documentation/playgroundsupport")!, label: {
                        Label("Playground Support", systemImage: "link")
                    })
                    Link(destination: URL(string: "https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html")!, label: {
                        Label("Markup Formatting Reference", systemImage: "link")
                    })
                    Link(destination: URL(string: "https://developer.apple.com/download/all/?q=Swift%20Playgrounds%20Author%20Template")!, label: {
                        Label("Swift Playgrounds Author Template", systemImage: "link")
                    })
                }
                .font(.footnote)
            } header: {
                Text("Some Documentation")
            }
        }
        .navigationBarTitle("Playground Book", displayMode: .inline)
    }
}

#Preview("Playground Book") {
    NavigationStack {
        BookView()
    }
}
