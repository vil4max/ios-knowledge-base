import Foundation

struct ImageSetBuilder {
    enum ImageType: String, CaseIterable, Identifiable {
        case png, jpg, svg, pdf, symbol, appicon
        
        var id: String { self.rawValue }
        
        var folderExtension: String {
            switch self {
            case .symbol: return "symbolset"
            case .appicon: return "appiconset"
            default: return "imageset"
            }
        }
    }
    
    let name: String
    let type: ImageType
    let isTemplate: Bool
    let isAdaptive: Bool
    
    func build() -> String {
        switch type {
        case .png, .jpg:
            return bitmapJSON()
        case .svg, .pdf:
            return vectorJSON()
        case .symbol:
            return symbolJSON()
        case .appicon:
            return appIconJSON()
        }
    }
    
    private func bitmapJSON() -> String {
        let adaptive = isAdaptive ? darkVariants(for: type) : ""
        let template = isTemplate ? ",\n  \"properties\": {\n    \"template-rendering-intent\": \"template\"\n  }" : ""
        
        return """
{
  "images" : [
    {
      "filename" : "\(name).\(type.rawValue)",
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "filename" : "\(name)@2x.\(type.rawValue)",
      "idiom" : "universal",
      "scale" : "2x"
    },
    {
      "filename" : "\(name)@3x.\(type.rawValue)",
      "idiom" : "universal",
      "scale" : "3x"
    }\(adaptive)
  ],
  \"info\": {
    \"author\": \"xcode\",
    \"version\": 1
  }\(template)
}
"""
    }
    
    private func darkVariants(for type: ImageType) -> String {
        """
,
    {
      \"idiom\": \"universal\",
      \"filename\": \"\(name)-dark.\(type.rawValue)\",
      \"appearances\": [
        {
          \"appearance\": \"luminosity\",
          \"value\": \"dark\"
        }
      ],
      \"scale\": \"1x\"
    },
    {
      \"idiom\": \"universal\",
      \"filename\": \"\(name)-dark@2x.\(type.rawValue)\",
      \"appearances\": [
        {
          \"appearance\": \"luminosity\",
          \"value\": \"dark\"
        }
      ],
      \"scale\": \"2x\"
    },
    {
      \"idiom\": \"universal\",
      \"filename\": \"\(name)-dark@3x.\(type.rawValue)\",
      \"appearances\": [
        {
          \"appearance\": \"luminosity\",
          \"value\": \"dark\"
        }
      ],
      \"scale\": \"3x\"
    }
"""
    }
    
    private func vectorJSON() -> String {
      let darkString = """
,
    {
      "appearances": [
        {
          "appearance": "luminosity",
          "value": "dark"
        }
      ],
      "filename": "\(name)-dark.\(type.rawValue)",
      "idiom": "universal"
    }
"""
        let dark = isAdaptive ? darkString : ""
        
        let templateString = """
"template-rendering-intent": "template",
"""
        let template = isTemplate ? templateString : ""
        
        return """
{
  "images" : [
    {
      "filename" : "\(name).\(type.rawValue)",
      "idiom" : "universal"
    }\(dark)
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  },
  "properties" : {
    \(template)\"preserves-vector-representation\": true
  }
}
"""
    }
    
    private func symbolJSON() -> String {
        """
{
  "symbols" : [
    {
      "filename" : "\(name).svg",
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
    }
    
    private func appIconJSON() -> String {
        """
{
  "images" : [
    {
      "filename" : "\(name).png",
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
"""
    }
}
