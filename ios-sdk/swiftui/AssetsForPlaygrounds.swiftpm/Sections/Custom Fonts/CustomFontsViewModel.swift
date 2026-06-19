import SwiftUI

class CustomFontsViewModel: ObservableObject {
    func copyMyFontToClipboard() {
        ClipboardHelper.copy("""
import SwiftUI

public struct MyFont {
    public static func registerFonts() {
        registerFont(bundle: Bundle.main , fontName: "YOUR-FONT-FILE-HERE", fontExtension: ".ttf")
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
""")
    }
    
    func copyInitToClipboard() {
        ClipboardHelper.copy("""
init() {
    MyFont.registerFonts()
}
""")
    }
    
    func copyModifierUsageToClipboard() {
        ClipboardHelper.copy("""
.font(.custom("FONT-NAME", size: 16, relativeTo: .body))
""")
    }
}
