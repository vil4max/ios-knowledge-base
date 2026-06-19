import PlaygroundSupport
import UIKit

let liveView = LiveViewController()
liveView.videoURL = #fileLiteral(resourceName: "1-2.mp4")
PlaygroundPage.current.liveView = liveView

