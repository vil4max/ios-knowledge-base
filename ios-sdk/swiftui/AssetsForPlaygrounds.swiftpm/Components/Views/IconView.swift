import SwiftUI

struct IconView: View {
    let icon: String
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(color)
            .frame(width: 40, height: 40)
            .overlay(
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
            )
            .padding(.trailing, 8)
    }
}

#Preview {
    IconView(icon: "book.fill",
             color: .brown)
}
