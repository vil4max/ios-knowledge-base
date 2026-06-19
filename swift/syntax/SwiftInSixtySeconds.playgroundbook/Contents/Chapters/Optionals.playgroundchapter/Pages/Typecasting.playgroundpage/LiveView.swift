import PlaygroundSupport
import UIKit

let liveView = LiveViewController()
liveView.videoURL = #fileLiteral(resourceName: "10-10.mp4")
PlaygroundPage.current.liveView = liveView

