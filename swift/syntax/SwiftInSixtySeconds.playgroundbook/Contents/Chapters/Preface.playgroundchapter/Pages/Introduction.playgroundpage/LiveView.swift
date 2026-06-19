import PlaygroundSupport
import UIKit

let liveView = LiveViewController()
liveView.videoURL = #fileLiteral(resourceName: "0-1.mp4")
PlaygroundPage.current.liveView = liveView

