import SwiftUI

class ColorSetViewModel: ObservableObject {
    @Published var colorName: String = ""
    @Published var isAdaptive: Bool = false
    @Published var lightColor: Color = .black
    @Published var darkColor: Color = .white
    
    func copyColorSetToClipboard() {
        ClipboardHelper.copy("\(colorName).colorset")
    }

    func copyContentsToClipboard() {
        ClipboardHelper.copy("Contents.json")
    }

    func copyColorToClipboard() {
        let builder = ColorSetBuilder(
            lightColor: UIColor(lightColor),
            darkColor: isAdaptive ? UIColor(darkColor) : nil
        )
        let json = builder.build(adaptive: isAdaptive)
        ClipboardHelper.copy(json)
    }
}
