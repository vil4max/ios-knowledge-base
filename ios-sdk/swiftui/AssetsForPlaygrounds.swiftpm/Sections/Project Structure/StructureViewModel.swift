import SwiftUI

class StructureViewModel: ObservableObject {
    func copyAssetsToClipboard() {
        ClipboardHelper.copy("Assets.xcassets")
    }
    
    func copyContentsToClipboard() {
        ClipboardHelper.copy("Contents.json")
    }
    
    func copyJSONToClipboard() {
        ClipboardHelper.copy("""
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
""")
    }
}
