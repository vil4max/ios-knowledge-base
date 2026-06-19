import SwiftUI

struct SectionInfo: Identifiable {
	let id = UUID()
	let text: String
	let icon: String
	let color: Color
	let destination: AnyView
}
