import SwiftUI

struct MenuItemView: View {
    let text: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            IconView(icon: icon,
                     color: color)
            Text(text)
        }
    }
}

#Preview {
    MenuItemView(text: "Playground Book",
                 icon: "book.fill",
                 color: .brown)
}
