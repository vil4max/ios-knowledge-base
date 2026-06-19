import MDKit

let builder = MarkdownBuilder()
    .addHeading("Apple Product Guide", level: 1)
    .addText("Explore some of the products offered by ")
    .addBoldText("Apple")
    .addText(" known for their ")
    .addItalicText("sleek design")
    .addText(" and innovative technology.")
    .addNewLine()
    .addNewLine()
    
    .addHeading("Insanely Great Products", level: 2)
    .addListItem("Mac Studio M2 Max")
    .addListItem("iPad Pro 13-inch M4")
    .addListItem("iPhone 15 Pro Max")
    .addListItem("Apple Vision Pro")
    .addListItem("Apple Watch Ultra")
    .addNewLine()
    
    .addHeading("Apple Leadership")
    .addListItem("Tim Cook", ordered: true, number: 1)
    .addListItem("Craig Federighi", ordered: true, number: 2)
    .addListItem("Greg “Joz” Joswiak", ordered: true, number: 3)
    .addListItem("John Ternus", ordered: true, number: 4)
    .addNewLine()
    
    .addHeading("Featured Product", level: 2)
    .addText("The ")
    .addBoldText("iPad Pro")
    .addText(", known for its ")
    .addItalicText("power and performance")
    .addText(", features the latest in Apple silicon technology.")
    .addNewLine()
    .addNewLine()
    
    .addText("For more information, visit the ")
    .addLink("official Apple website", url: "https://www.apple.com")
    .addText(".")
    .addNewLine()
    .addNewLine()
    
    .addHorizontalRule()
    
    .addBlockquote("Design is not just what it looks like and feels like. Design is how it works.")
    
    .addHorizontalRule()
    
    .addHeading("Example Code Block", level: 2)
    .addCodeBlock("""
func sayHello() {
    print("Hello, Swift!")
}
""", language: "swift")

print(builder.build())
