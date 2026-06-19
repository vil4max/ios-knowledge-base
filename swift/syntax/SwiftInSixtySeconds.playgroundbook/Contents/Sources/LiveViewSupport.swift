//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import PlaygroundSupport
import UIKit

public protocol PlaygroundValueConvertible {
    func asPlaygroundValue() -> PlaygroundValue
}

extension UIColor: PlaygroundValueConvertible {
    public func asPlaygroundValue() -> PlaygroundValue {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return .data(data)
    }
}

extension UIImage: PlaygroundValueConvertible {
    public func asPlaygroundValue() -> PlaygroundValue {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return .data(data)
    }
}

extension CIFilter: PlaygroundValueConvertible {
    public func asPlaygroundValue() -> PlaygroundValue {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        return .data(data)
    }
}

public func sendValue(_ value: PlaygroundValueConvertible) {
    let page = PlaygroundPage.current
    let proxy = page.liveView as! PlaygroundRemoteLiveViewProxy
    proxy.send(value.asPlaygroundValue())
}
