import SwiftUI

enum ClipboardHelper {
	static func copy(_ string: String) {
		UIPasteboard.general.string = string
	}
}
