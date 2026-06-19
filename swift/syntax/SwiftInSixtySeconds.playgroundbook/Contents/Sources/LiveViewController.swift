import AVKit
import AVFoundation
import PlaygroundSupport
import UIKit

public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    public var videoURL: URL?

    public func receive(_ message: PlaygroundValue) { }

    override public func viewDidLoad() {
        super.viewDidLoad()

        guard let videoURL = videoURL else { return }

        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        playerViewController.player = player

        addChild(playerViewController)
        view.addSubview(playerViewController.view)

        playerViewController.view.leadingAnchor.constraint(equalTo: liveViewSafeAreaGuide.leadingAnchor, constant: 10).isActive = true
        playerViewController.view.trailingAnchor.constraint(equalTo: liveViewSafeAreaGuide.trailingAnchor, constant: -10).isActive = true
        playerViewController.view.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: 10).isActive = true
        playerViewController.view.bottomAnchor.constraint(equalTo: liveViewSafeAreaGuide.bottomAnchor, constant: 0).isActive = true

        playerViewController.view.centerXAnchor.constraint(equalTo: liveViewSafeAreaGuide.centerXAnchor).isActive = true
        playerViewController.view.centerYAnchor.constraint(equalTo: liveViewSafeAreaGuide.centerYAnchor).isActive = true
        
        playerViewController.view.backgroundColor = .clear
        playerViewController.didMove(toParent: self)
    }
}
