import UIKit
import PlaygroundSupport

/*
 Q&A cards — Theme 3 UIKit lifecycle / layout vocabulary (Q21–Q28, Q44)

 View Programming Guide for iOS (lifecycle):
 https://developer.apple.com/documentation/uikit/view_controller_programming_guide/

 Checklist printed below matches the usual first-appearance sequence when the view loads and appears.
*/

final class LifecycleViewController: UIViewController {
    override func loadView() {
        print("loadView")
        let root = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        root.backgroundColor = .systemBackground
        view = root
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews — bounds:", view.bounds)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews — frame in window space soon")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
    }
}

let controller = LifecycleViewController()
PlaygroundPage.current.liveView = controller
controller.beginAppearanceTransition(true, animated: false)
controller.endAppearanceTransition()

print("\nframe vs bounds (same-sized child for demo):")
let child = UIView(frame: CGRect(x: 20, y: 80, width: 120, height: 40))
child.backgroundColor = .systemBlue
controller.view.addSubview(child)
print("child.frame (superview coords):", child.frame)
print("child.bounds (local coords):", child.bounds)
