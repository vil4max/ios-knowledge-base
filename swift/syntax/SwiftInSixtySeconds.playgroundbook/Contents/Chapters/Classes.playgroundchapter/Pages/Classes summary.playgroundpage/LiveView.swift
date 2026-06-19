import PlaygroundSupport
import UIKit

let liveView = LiveViewController()
liveView.videoURL = #fileLiteral(resourceName: "8-8.mp4")
PlaygroundPage.current.liveView = liveView

