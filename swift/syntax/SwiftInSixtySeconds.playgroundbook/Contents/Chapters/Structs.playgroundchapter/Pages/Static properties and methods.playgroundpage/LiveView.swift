import PlaygroundSupport
import UIKit

let liveView = LiveViewController()
liveView.videoURL = #fileLiteral(resourceName: "7-11.mp4")
PlaygroundPage.current.liveView = liveView

