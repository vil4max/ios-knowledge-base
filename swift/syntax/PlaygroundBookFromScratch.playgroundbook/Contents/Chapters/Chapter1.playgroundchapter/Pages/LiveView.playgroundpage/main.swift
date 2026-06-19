import UIKit
import PlaygroundSupport

var number = 0

let label = UILabel()
label.textColor = .lightGray
label.backgroundColor = .darkGray
label.textAlignment = .center
label.font = .systemFont(ofSize: 64, weight: .bold)
label.text = "\(number)"

Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
    number += 1
    label.text = "\(number)"
}

PlaygroundPage.current.setLiveView(label)
