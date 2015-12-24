//
//  UIView+Utils.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/24/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

extension UIRectEdge: Hashable {
    public var hashValue: Int {
        return Int(self.rawValue)
    }
}

extension UIView {
    func addBorder(edges edges: UIRectEdge, colour: UIColor = UIColor.whiteColor(), thickness: CGFloat = 1) -> [UIRectEdge: UIView] {
        var borders = [UIRectEdge: UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRectZero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.Top) || edges.contains(.All) {
            let top = border()
            addSubview(top)
            borders[.Top] = top
            top.addDimentionConstraints(.Height, constant: thickness)
            top.pinToSuperView(.Top, inset: 0, relation: .Equal)
        }
        
        if edges.contains(.Left) || edges.contains(.All) {
            let left = border()
            addSubview(left)
            borders[.Left] = left
            left.addDimentionConstraints(.Width, constant: thickness)
            left.pinToSuperView(.Leading, inset: 0, relation: .Equal)
        }
        
        if edges.contains(.Right) || edges.contains(.All) {
            let right = border()
            addSubview(right)
            borders[.Right] = right
            right.addDimentionConstraints(.Width, constant: thickness)
            right.pinToSuperView(.Trailing, inset: 0, relation: .Equal)
        }
        
        if edges.contains(.Bottom) || edges.contains(.All) {
            let bottom = border()
            addSubview(bottom)
            borders[.Bottom] = bottom
            bottom.addDimentionConstraints(.Height, constant: thickness)
            bottom.pinToSuperView(.Bottom, inset: 0, relation: .Equal)
        }
        
        return borders
    }
}