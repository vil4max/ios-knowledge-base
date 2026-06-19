import SwiftUI

class LocalizationViewModel: ObservableObject {
    @Published var pluralizationKey: String = ""
    @Published var pluralZero: String = ""
    @Published var pluralOne: String = ""
    @Published var pluralTwo: String = ""
    @Published var pluralFew: String = ""
    @Published var pluralMany: String = ""
    @Published var pluralOther: String = ""
    
    func copyDefaultToClipboard() {
        ClipboardHelper.copy("defaultLocalization: \"en\",")
    }
    
    func copyResourcesFolderToClipboard() {
        ClipboardHelper.copy("Resources")
    }
    
    func copyLprojFolderToClipboard() {
        ClipboardHelper.copy("en.lproj")
    }
    
    func copyStringsToClipboard() {
        ClipboardHelper.copy("Localizable.strings")
    }
    
    func copyStringsExampleToClipboard() {
        ClipboardHelper.copy(LocalizationBuilder.defaultStringsExample())
    }
    
    func copyStringsdictToClipboard() {
        ClipboardHelper.copy("Localizable.stringsdict")
    }
    
    func copyPluralizedContentToClipboard() {
        let entries: [LocalizationBuilder.PluralEntry] = [
            .init(category: "zero", value: pluralZero),
            .init(category: "one", value: pluralOne),
            .init(category: "two", value: pluralTwo),
            .init(category: "few", value: pluralFew),
            .init(category: "many", value: pluralMany),
            .init(category: "other", value: pluralOther)
        ]
        
        let builder = LocalizationBuilder(
            key: pluralizationKey,
            entries: entries
        )
        
        let plist = builder.buildStringsDict()
        ClipboardHelper.copy(plist)
    }
}
