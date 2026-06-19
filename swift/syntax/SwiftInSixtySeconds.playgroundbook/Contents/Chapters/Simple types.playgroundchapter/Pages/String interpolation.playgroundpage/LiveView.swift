import PlaygroundSupport
import UIKit

let liveView = LiveViewController()
liveView.videoURL = #fileLiteral(resourceName: "1-5.mp4")
PlaygroundPage.current.liveView = liveView

