import Foundation

struct LocalizationBuilder {
    struct PluralEntry {
        let category: String
        let value: String
    }
    
    let key: String
    let entries: [PluralEntry]
    
    func buildStringsDict() -> String {
        var xml = """
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>%lld \(key)</key>
    <dict>
        <key>NSStringLocalizedFormatKey</key>
        <string>%#@\(key)@</string>
        <key>\(key)</key>
        <dict>
            <key>NSStringFormatSpecTypeKey</key>
            <string>NSStringPluralRuleType</string>
            <key>NSStringFormatValueTypeKey</key>
            <string>d</string>
"""
        
        for entry in entries where !entry.value.isEmpty {
            xml += """

            <key>\(entry.category)</key>
            <string>\(entry.value)</string>
"""
        }
        
        xml += """

        </dict>
    </dict>
</dict>
</plist>
"""
        return xml
    }
    
    static func defaultStringsExample() -> String {
        """
\"welcome_message\" = \"Welcome to our app!\";
\"completed_tasks\" = \"You have completed %d tasks.\";
\"meeting_schedule\" = \"Meeting with %@ on %@.\";
"""
    }
} 
