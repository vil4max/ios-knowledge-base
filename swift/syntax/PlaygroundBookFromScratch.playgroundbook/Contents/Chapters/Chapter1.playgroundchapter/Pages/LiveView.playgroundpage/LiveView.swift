import UIKit
import PlaygroundSupport

let label = UILabel()
label.textColor = .darkGray
label.backgroundColor = .lightGray
label.textAlignment = .center
label.font = .systemFont(ofSize: 64, weight: .bold)
label.text = "0"

PlaygroundPage.current.setLiveView(label)
