public class MarkdownBuilder {
    private var markdownText: String = ""
    
    public init() {}
    
    @discardableResult
    public func addHeading(_ text: String, level: Int = 1) -> MarkdownBuilder {
        let markdownLevel = String(repeating: "#", count: min(level, 6))
        markdownText += "\(markdownLevel) \(text)\n\n"
        return self
    }
    
    @discardableResult
    public func addText(_ text: String) -> MarkdownBuilder {
        markdownText += text
        return self
    }
    
    @discardableResult
    public func addNewLine() -> MarkdownBuilder {
        markdownText += "\n"
        return self
    }
    
    @discardableResult
    public func addListItem(_ item: String, ordered: Bool = false, number: Int = 1) -> MarkdownBuilder {
        if ordered {
            markdownText += "\(number). \(item)\n"
        } else {
            markdownText += "- \(item)\n"
        }
        return self
    }
    
    @discardableResult
    public func addBoldText(_ text: String) -> MarkdownBuilder {
        markdownText += "**\(text)**"
        return self
    }
    
    @discardableResult
    public func addItalicText(_ text: String) -> MarkdownBuilder {
        markdownText += "_\(text)_"
        return self
    }
    
    @discardableResult
    public func addLink(_ text: String, url: String) -> MarkdownBuilder {
        markdownText += "[\(text)](\(url))"
        return self
    }
    
    @discardableResult
    public func addBlockquote(_ text: String) -> MarkdownBuilder {
        markdownText += "> \(text)\n\n"
        return self
    }
    
    @discardableResult
    public func addCodeBlock(_ code: String, language: String = "") -> MarkdownBuilder {
        markdownText += "```\(language)\n\(code)\n```\n\n"
        return self
    }
    
    @discardableResult
    public func addHorizontalRule() -> MarkdownBuilder {
        markdownText += "---\n\n"
        return self
    }
    
    public func build() -> String {
        return markdownText
    }
}
