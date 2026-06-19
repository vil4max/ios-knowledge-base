import SwiftUI

class BookViewModel: ObservableObject {
    @Published var contentsGroup = false
    @Published var chaptersGroup = false
    @Published var chapterItem = false
    @Published var pagesGroup = false
    @Published var pageItem = false
    @Published var pageItemTemplate = false
    
    @Published var modulesGroup = false
    @Published var moduleItem = false
    @Published var moduleSourcesItem = false
    @Published var userModulesGroup = false
    @Published var userModuleItem = false
    @Published var userModuleSourcesItem = false
    
    @Published var htmlCutscene = false
    @Published var swiftCutscene = false
    
    func copyPlaygroundBookName() {
        ClipboardHelper.copy("Book.playgroundbook")
    }
    
    func copyPlaygroundChapterName() {
        ClipboardHelper.copy("Chapter.playgroundchapter")
    }
    
    func copyPlaygroundPageName() {
        ClipboardHelper.copy("Page.playgroundpage")
    }
    
    func copyBookManifest() {
        let manifest = BookBuilder.buildBookManifest(from: BookBuilder.BookManifestInfo(
            chapters: [
                "Chapter 1.playgroundchapter",
                "Chapter 2.playgroundchapter",
                "Chapter 3.playgroundchapter"
            ]
        ))
        ClipboardHelper.copy(manifest)
    }
    
    func copyChapterManifest() {
        ClipboardHelper.copy("""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Name</key>
    <string>My Playground</string>
    <key>TemplatePageFilename</key>
    <string>Template.playgroundpage</string>
    <key>InitialUserPages</key>
    <array>
        <string>Page.playgroundpage</string>
        <string>Other Page.playgroundpage</string>
    </array>
    <key>Pages</key>
    <array>
        <string>Page.playgroundpage</string>
        <string>Other Page.playgroundpage</string>
    </array>
</dict>
</plist>
""")
    }
    
    func copyPageManifest() {
        ClipboardHelper.copy("""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Name</key>
    <string>My Playground</string>
    <key>LiveViewEdgeToEdge</key>
    <false/>
    <key>LiveViewMode</key>
    <string>HiddenByDefault</string>
</dict>
</plist>
""")
    }
    
    func copyPageMain() {
        ClipboardHelper.copy("// main.swift")
    }
    
    func copyPageLiveView() {
        ClipboardHelper.copy("// LiveView.swift")
    }
    
    func copyHiddenModule() {
        ClipboardHelper.copy("// Modules\\n// ModuleName.playgroundmodule\\n// Sources")
    }
    
    func copySharedModule() {
        ClipboardHelper.copy("// UserModules\\n// ModuleName.playgroundmodule\\n// Sources")
    }
    
    func copyPrivateResources() {
        ClipboardHelper.copy("PrivateResources")
    }
    
    func copyPublicResources() {
        ClipboardHelper.copy("PublicResources")
    }
    
    func copyCutsceneSwiftManifest() {
        ClipboardHelper.copy("""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Name</key>
    <string>Cutscene Name</string>
</dict>
</plist>
""")
    }
    
    func copyCutsceneHTMLManifest() {
        ClipboardHelper.copy("""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Name</key>
    <string>Cutscene Name</string>
    <key>CutsceneReference</key>
    <string>H5Square.html</string>
</dict>
</plist>
""")
    }
    
    func copyHintsFile() {
        ClipboardHelper.copy("""
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Hints</key>
    <array>
        <dict>
            <key>Content</key>
            <string>Look at the `characters` property of `String`.</string>
        </dict>
        <dict>
            <key>Content</key>
            <string>This hint is initially hidden by a spoiler button.</string>
            <key>SpoilerButtonTitle</key>
            <string>Show Spoiler</string>
        </dict>
        <dict>
            <key>FileReference</key>
            <string>OutOfBandHint.txt</string>
        </dict>
        <dict>
            <key>FileReference</key>
            <string>OutOfBandHintWithSpoilerButton.txt</string>
            <key>SpoilerButtonTitle</key>
            <string>Show Spoiler</string>
        </dict>
    </array>
</dict>
</plist>
""")
    }
}
