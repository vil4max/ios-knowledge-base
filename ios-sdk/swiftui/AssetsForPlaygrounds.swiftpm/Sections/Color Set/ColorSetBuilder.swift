import SwiftUI

struct ColorSetBuilder {
    let lightColor: UIColor
    let darkColor: UIColor?
    
    func build(adaptive: Bool) -> String {
        let lightComponents = rgbaComponents(from: lightColor)
        var json = """
{
  "colors": [
    {
      "idiom": "universal",
      "color": {
        "color-space": "srgb",
        "components": {
          "red": "\(lightComponents.red)",
          "green": "\(lightComponents.green)",
          "blue": "\(lightComponents.blue)",
          "alpha": "\(lightComponents.alpha)"
        }
      }
    }
"""
        
        if adaptive, let darkColor {
            let darkComponents = rgbaComponents(from: darkColor)
            json += """
,
    {
      \"idiom\": \"universal\",
      \"appearances\": [
        {
          \"appearance\": \"luminosity\",
          \"value\": \"dark\"
        }
      ],
      \"color\": {
        \"color-space\": \"srgb\",
        \"components\": {
          \"red\": \"\(darkComponents.red)\",
          \"green\": \"\(darkComponents.green)\",
          \"blue\": \"\(darkComponents.blue)\",
          \"alpha\": \"\(darkComponents.alpha)\"
        }
      }
    }
"""
        }
        
        json += """

  ],
  "info": {
    "version": 1,
    "author": "xcode"
  }
}
"""
        
        return json
    }
    
    private func rgbaComponents(from color: UIColor) -> (red: String, green: String, blue: String, alpha: String) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (
            String(format: "%.2f", red),
            String(format: "%.2f", green),
            String(format: "%.2f", blue),
            String(format: "%.2f", alpha)
        )
    }
}
