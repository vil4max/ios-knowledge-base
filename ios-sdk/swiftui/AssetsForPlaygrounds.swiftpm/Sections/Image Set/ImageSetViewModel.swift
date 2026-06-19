import SwiftUI

class ImageSetViewModel: ObservableObject {
    @Published var imageName: String = ""
    @Published var isAdaptive: Bool = false
    @Published var isTemplate: Bool = false
    @Published var imageType: ImageSetBuilder.ImageType = .png

    var footerAdaptive: some View {
        if isAdaptive && imageType != .symbol && imageType != .appicon {
            return Text("For **dark mode** support, add a ‘-dark’ suffix to each counterpart file name for compatibility.\(adaptiveExample)")
        } else {
            return EmptyView()
        }
    }

    var adaptiveExample: String {
        imageName.isEmpty ? "" : "\n\nExample: \(imageName)-dark.\(imageType.rawValue)"
    }

    var footerType: some View {
        switch imageType {
        case .png, .jpg:
            return Text("Selecting **\(imageType.rawValue.uppercased())** requires providing three sizes: include `@2x` and `@3x` in the filenames for retina displays.")
        case .appicon:
            return Text("Name the app icon `‘AppIcon’` to ensure it’s recognized as the main app icon. Also remember that it has to be 1024x1024.")
        case .symbol:
            return Text("If you are working with custom symbols, I recommend you watch the **WWDC21** session `‘Create custom symbols‘`.")
        default:
            return EmptyView()
        }
    }
    
    var placeCopy: String {
        (imageType == .png || imageType == .jpg || isAdaptive) ? "Place image files" : "Place image file"
    }
    
    func copyImageSetToClipboard() {
        ClipboardHelper.copy("\(imageName).\(imageType.folderExtension)")
    }

    func copyContentsToClipboard() {
        ClipboardHelper.copy("Contents.json")
    }

    func copyImageToClipboard() {
        let builder = ImageSetBuilder(
            name: imageName,
            type: imageType,
            isTemplate: isTemplate,
            isAdaptive: isAdaptive
        )
        ClipboardHelper.copy(builder.build())
    }
}
