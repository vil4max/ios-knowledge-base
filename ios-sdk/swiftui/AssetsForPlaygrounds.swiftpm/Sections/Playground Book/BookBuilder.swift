import Foundation

struct BookBuilder {
    struct BookManifestInfo {
        var chapters: [String]
        var contentIdentifier: String = "com.apple.playgrounds.blank"
        var contentVersion: String = "1.0"
        var deploymentTarget: String = "ios-current"
        var developmentRegion: String = "en"
        var swiftVersion: String = "5.9"
        var version: String = "8.0"
        var userModuleMode: String = "Full" // or "Limited", "Disabled"
        var hasMeaningfulResetPoint: Bool = false
        var imageReference: String = "playground-cover.png"
        var subtitle: String = "Optional subtitle"
    }
    
    static func buildBookManifest(from info: BookManifestInfo) -> String {
        let chaptersList = info.chapters.map { "<string>\($0)</string>" }.joined(separator: "\n        ")
        return """
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Chapters</key>
    <array>
        \(chaptersList)
    </array>
    <key>ContentIdentifier</key>
    <string>\(info.contentIdentifier)</string>
    <key>ContentVersion</key>
    <string>\(info.contentVersion)</string>
    <key>DeploymentTarget</key>
    <string>\(info.deploymentTarget)</string>
    <key>DevelopmentRegion</key>
    <string>\(info.developmentRegion)</string>
    <key>SwiftVersion</key>
    <string>\(info.swiftVersion)</string>
    <key>Version</key>
    <string>\(info.version)</string>
    <key>UserAutoImportedAuxiliaryModules</key>
    <array/>
    <key>UserModuleMode</key>
    <string>\(info.userModuleMode)</string>
    <key>HasMeaningfulResetPoint</key>
    <\(info.hasMeaningfulResetPoint)/>
    <key>ImageReference</key>
    <string>\(info.imageReference)</string>
    <key>Subtitle</key>
    <string>\(info.subtitle)</string>
</dict>
</plist>
"""
    }
}
