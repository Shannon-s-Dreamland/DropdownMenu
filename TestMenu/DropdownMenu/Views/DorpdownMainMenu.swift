//
//  DorpdownMenuMainMenu.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/20/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: - Main Menu Item

class DropdownMenuItem: UIView {
    // MARK: Properties

    private var triangleImageView: UIImageView = {
        let image = UIImage(named: "dropdown_menu_triangle")?.imageWithRenderingMode(.AlwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = DropdownMenuConfiguration.normalColor
        imageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = DropdownMenuConfiguration.mainMenuFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var selected: Bool = false {
        didSet {
            if selected {
                titleLabel.textColor = DropdownMenuConfiguration.highlightColor
                triangleImageView.tintColor = DropdownMenuConfiguration.highlightColor
                triangleImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }
            else {
                titleLabel.textColor = DropdownMenuConfiguration.normalColor
                triangleImageView.tintColor = DropdownMenuConfiguration.normalColor
                triangleImageView.transform = CGAffineTransformMakeRotation(0)
            }
        }
    }
    
    // MARK: Initializers
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        
        titleLabel.text = title
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        addSubview(triangleImageView)
        addSubview(titleLabel)
        
        titleLabel.positionToSuperView(horizontal: .Center, hOffset: 0, vertical: .Center, vOffset: 0)
        triangleImageView.positionRelativeToView(titleLabel, direction: .Trailing, space: DropdownMenuConfiguration.space)
    }
    
}

// MARK: - Main Menu Delegate

protocol DropdownMenuDelegate: class {
    func mainMenuItemAtIndexSelected(index: Int)
}

// MARK: - Main Menu

class DropdownMenu: UIView {
    // MARK: Properties
    
    private let menuItems: [DropdownMenuItem]
    private var selectedItem: DropdownMenuItem?
    
    weak var delegate: DropdownMenuDelegate?
    
    // MARK: Initializers

    init(items: [String], delegate: DropdownMenuDelegate) {
        self.delegate = delegate
        
        var menuItems = [DropdownMenuItem]()
        for (index, title) in items.enumerate() {
            let item = DropdownMenuItem(title: title)
            item.tag = index
            item.translatesAutoresizingMaskIntoConstraints = false
            menuItems.append(item)
        }
        self.menuItems = menuItems
        
        super.init(frame: CGRect.zero)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        backgroundColor = DropdownMenuConfiguration.mainMenuBackgoundColor
        layer.borderWidth = DropdownMenuConfiguration.mainMenuBorderWidth
        layer.borderColor = DropdownMenuConfiguration.mainMenuBorderColor.CGColor
        
        menuItems.forEach { item in
            addSubview(item)
        }
        
        if menuItems.count != 0 {
            let menuItemsTuple: [ViewTuple] = menuItems.map { item in
                return (item, 1.0)
            }
            LayoutKit.arrangeViews(.Horizontal, viewsTuple: menuItemsTuple)
        }
    }
    
    // MARK: Methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let position = touch.locationInView(self)
        
        guard let touchedView = hitTest(position, withEvent: event) as? DropdownMenuItem else { return }
        
        touchedView.selected = true
        if selectedItem != touchedView {
            selectedItem?.selected = false
        }
        selectedItem = touchedView
        
        delegate?.mainMenuItemAtIndexSelected(touchedView.tag)
    }
    
    func setTitleForSelectedItem(title: String?) {
        if let title = title {
            selectedItem?.titleLabel.text = title
        }
        selectedItem?.selected = false
    }
    
}
