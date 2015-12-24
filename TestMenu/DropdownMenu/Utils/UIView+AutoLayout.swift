//
//  UIView+AutoLayout.swift
//  Client
//
//  Created by Shannon Wu on 12/22/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import UIKit

// MARK: - Types

enum LayoutDirection {
    case Horizontal
    case Vertical
    case Both
}

extension UIView {
    typealias Relation = NSLayoutRelation
    
    enum Horizontal {
        case Left
        case Center
        case Right
        
        var attribute: NSLayoutAttribute {
            switch self {
            case .Left:
                return .Left
            case .Right:
                return .Right
            case .Center:
                return .CenterX
            }
        }
    }
    
    enum Vertical {
        case Top
        case Center
        case Bottom
        
        var attribute: NSLayoutAttribute {
            switch self {
            case .Top:
                return .Top
            case .Center:
                return .CenterY
            case .Bottom:
                return .Bottom
            }
        }
    }
    
    enum Dimension {
        case Width
        case Height
        
        var attribute: NSLayoutAttribute {
            switch self {
            case .Width:
                return .Width
            case .Height:
                return .Height
            }
        }
    }
    
    enum Direction {
        case Leading
        case Trailing
        case Bottom
        case Top
    }
    
    // MARK: - Layout Methods
    
    func addDimentionConstraints(dimention: Dimension, constant: CGFloat, relation: Relation = .Equal) {
        var constraints = [NSLayoutConstraint]()
        switch dimention {
        case .Width:
            constraints.append(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: constant))
        case .Height:
            constraints.append(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: relation, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: constant))
        }
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func positionToSuperView(horizontal horizontal: Horizontal, hOffset: CGFloat, vertical: Vertical, vOffset: CGFloat) {
        guard let superView = self.superview else {
            assertionFailure("在调用这个方法前要将它加入到父 View 上面")
            return
        }
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(NSLayoutConstraint(item: self, attribute: horizontal.attribute, relatedBy: .Equal, toItem: superView, attribute: horizontal.attribute, multiplier: 1.0, constant: hOffset))
        constraints.append(NSLayoutConstraint(item: self, attribute: vertical.attribute, relatedBy: .Equal, toItem: superView, attribute: vertical.attribute, multiplier: 1.0, constant: vOffset))
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func pinToSuperView(direction: Direction, inset: CGFloat, relation: Relation) {
        guard self.superview != nil else {
            assertionFailure("在调用这个方法前要将它加入到父 View 上面")
            return
        }
        
        var constraints = [NSLayoutConstraint]()
        let views = ["self": self]
        var formats = [String]()
        
        let relationSubFormat: String
        switch relation {
        case .GreaterThanOrEqual:
            relationSubFormat = ">=\(inset)"
        case .Equal:
            relationSubFormat = "==\(inset)"
        case .LessThanOrEqual:
            relationSubFormat = "<=\(inset)"
        }
        
        switch direction {
        case .Top:
            formats.append("|-(\(relationSubFormat))-[self]|")
            formats.append("V:|[self]")
        case .Trailing:
            formats.append("V:|[self]|")
            formats.append("[self]-(\(relationSubFormat))-|")
        case .Bottom:
            formats.append("V:[self]-(\(relationSubFormat))-|")
            formats.append("|[self]|")
        case .Leading:
            formats.append("V:|[self]|")
            formats.append("|-(\(relationSubFormat))-[self]")
        }
        
        formats.forEach { format in
            constraints += NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: views)
        }
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func positionRelativeToView(view: UIView, direction: Direction, space: CGFloat) {
        guard view.superview == self.superview else {
            assertionFailure("在调用这个方法前要将它它们加入到同一个 View 的下面")
            return
        }
        
        var constraints = [NSLayoutConstraint]()
        
        let selfSideAttribute: NSLayoutAttribute
        let viewSideAttribute: NSLayoutAttribute
        let centerAttribute: NSLayoutAttribute
        switch direction {
        case .Top:
            selfSideAttribute = .Bottom
            viewSideAttribute = .Top
            centerAttribute = .CenterX
        case .Trailing:
            selfSideAttribute = .Leading
            viewSideAttribute = .Trailing
            centerAttribute = .CenterY
        case .Bottom:
            selfSideAttribute = .Top
            viewSideAttribute = .Bottom
            centerAttribute = .CenterX
        case .Leading:
            selfSideAttribute = .Trailing
            viewSideAttribute = .Leading
            centerAttribute = .CenterY
        }
        
        constraints.append(NSLayoutConstraint(item: self, attribute: selfSideAttribute, relatedBy: .Equal, toItem: view, attribute: viewSideAttribute, multiplier: 1.0, constant: space))
        constraints.append(NSLayoutConstraint(item: self, attribute: centerAttribute, relatedBy: .Equal, toItem: view, attribute: centerAttribute, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    func fillSuperView(direction: LayoutDirection, edgeInsets: UIEdgeInsets = UIEdgeInsetsZero) {
        guard self.superview != nil else {
            assertionFailure("在调用这个方法前要将它加入到父 View 上面")
            return
        }
        
        let view = ["self": self]
        var constraints = [NSLayoutConstraint]()
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-\(edgeInsets.left)-[self]-\(edgeInsets.right)-|", options: [], metrics: nil, views: view)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(edgeInsets.top)-[self]-\(edgeInsets.bottom)-|", options: [], metrics: nil, views: view)
        
        switch direction {
        case .Horizontal:
            constraints += hConstraints
        case .Vertical:
            constraints += vConstraints
        case .Both:
            constraints += hConstraints
            constraints += vConstraints
        }
        NSLayoutConstraint.activateConstraints(constraints)
    }
}

typealias ViewTuple = (view: UIView, multiplierRelativeToFirstView: CGFloat)
struct LayoutKit {
    
    static func arrangeViews(direction: LayoutDirection, viewsTuple: [ViewTuple]) {
        
        var viewsDict = [String: AnyObject]()
        guard let viewFlag = viewsTuple.first?.view.superview else {
            assertionFailure("在调用这个方法前要将它加入到父 View 上面")
            return
        }
        for (index, viewTuple) in viewsTuple.enumerate() {
            viewsDict["Item\(index)"] =  viewTuple.view
            if viewFlag != viewTuple.view.superview {
                assertionFailure("这个方法的所有视图必须放在同一个父视图中")
                return
            }
        }
        
        var constraints = [NSLayoutConstraint]()
        switch direction {
        case .Horizontal:
            for (index, viewTuple) in viewsTuple.enumerate() {
                let format: String
                if index == 0 {
                    format = "|[Item\(index)]"
                }
                else if index == viewsTuple.count - 1 {
                    format = "[Item\(index-1)][Item\(index)]|"
                }
                else {
                    format = "[Item\(index-1)][Item\(index)]"
                }
                constraints += NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: viewsDict)
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[Item\(index)]|", options: [], metrics: nil, views: viewsDict)
                constraints.append(NSLayoutConstraint(item: viewsDict["Item\(index)"]!, attribute: .Width, relatedBy: .Equal, toItem: viewsDict["Item0"], attribute: .Width, multiplier: viewTuple.multiplierRelativeToFirstView, constant: 0))
            }
        case .Vertical:
            for (index, viewTuple) in viewsTuple.enumerate() {
                let format: String
                if index == 0 {
                    format = "V:|[Item\(index)]"
                }
                else if index == viewsTuple.count - 1 {
                    format = "V:[Item\(index-1)][Item\(index)]|"
                }
                else {
                    format = "V:[Item\(index-1)][Item\(index)]"
                }
                constraints += NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: viewsDict)
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[Item\(index)]|", options: [], metrics: nil, views: viewsDict)
                constraints.append(NSLayoutConstraint(item: viewsDict["Item\(index)"]!, attribute: .Height, relatedBy: .Equal, toItem: viewsDict["Item0"], attribute: .Height, multiplier: viewTuple.multiplierRelativeToFirstView, constant: 0))
            }
        case .Both: ()
        }
        NSLayoutConstraint.activateConstraints(constraints)
    }
}