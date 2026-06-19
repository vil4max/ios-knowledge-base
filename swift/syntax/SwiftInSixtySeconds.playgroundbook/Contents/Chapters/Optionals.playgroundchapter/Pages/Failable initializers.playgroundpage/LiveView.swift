import PlaygroundSupport
import UIKit

let liveView = LiveViewController()
liveView.videoURL = #fileLiteral(resourceName: "10-9.mp4")
PlaygroundPage.current.liveView = liveView

