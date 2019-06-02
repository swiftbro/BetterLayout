//
//  GeometryExtension.swift
//  BetterLayout
//
//  Created by Vlad Che on 7/2/19.
//  Copyright © 2019 Swift Bro. All rights reserved.
//

import UIKit

extension UITabBar {
    var height: CGFloat {
        get { return frame.size.height }
        set {
            changeFrame{
                $0.height = newValue
                guard let superview = superview else { return }
                $0.y = superview.frame.size.height - newValue
            }            
        }
    }
}

extension UIView {
    func changeFrame(_ transform: (RectRef) -> Void) {
        let rect = RectRef(with: frame)
        transform(rect)
        frame = rect.cgRect
    }
}

fileprivate class SizeRef {
    var width: CGFloat = 0
    var height: CGFloat = 0
}

fileprivate class PointRef {
    var x: CGFloat = 0
    var y: CGFloat = 0
}

class RectRef {
    fileprivate var size: SizeRef = SizeRef()
    fileprivate var origin: PointRef = PointRef()
    
    init(with cgRect: CGRect) {
        x = cgRect.origin.x
        y = cgRect.origin.y
        width = cgRect.width
        height = cgRect.height
    }
    
    var cgRect: CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension RectRef {
    var x: CGFloat {
        get { return origin.x }
        set { origin.x = newValue }
    }
    var y: CGFloat {
        get { return origin.y }
        set { origin.y = newValue }
    }
    var width: CGFloat {
        get { return size.width }
        set { size.width = newValue }
    }
    var height: CGFloat {
        get { return size.height }
        set { size.height = newValue }
    }
}
