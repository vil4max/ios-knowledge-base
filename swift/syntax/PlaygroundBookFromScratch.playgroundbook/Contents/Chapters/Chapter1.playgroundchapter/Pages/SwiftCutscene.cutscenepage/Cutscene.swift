import UIKit
import PlaygroundSupport

class CutsceneButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("Go to the next page", for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
        self.backgroundColor = .gray
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        self.titleLabel?.minimumScaleFactor = 0.5
        self.addTarget(self, action: #selector(goToNextPage), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func goToNextPage() {
        PlaygroundPage.current.navigateTo(page: .next)
    }
}

let cutsceneButton = CutsceneButton()
PlaygroundPage.current.setLiveView(cutsceneButton)
