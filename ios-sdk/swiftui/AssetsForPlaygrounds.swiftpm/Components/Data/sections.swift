import SwiftUI

let sections = [
	SectionInfo(text: "Project structure",
				icon: "folder.fill",
				color: .red,
				destination: AnyView(StructureView())),
	SectionInfo(text: "Add color",
				icon: "swatchpalette.fill",
				color: .green,
				destination: AnyView(ColorSetView())),
	SectionInfo(text: "Add image",
				icon: "photo.on.rectangle.angled",
				color: .blue,
				destination: AnyView(ImageSetView())),
	SectionInfo(text: "Use custom fonts",
				icon: "textformat",
				color: .purple,
				destination: AnyView(CustomFontsView())),
	SectionInfo(text: "Localization strings",
				icon: "bubble.left.and.bubble.right.fill",
				color: .orange,
				destination: AnyView(LocalizationView()))
]
