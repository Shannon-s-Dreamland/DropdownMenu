//
//  DropdownCollectionView.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/20/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: - Collection View Cell

class DropdownCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = DropdownMenuConfiguration.collectionViewSubmenuBodyFont
        label.textColor = DropdownMenuConfiguration.normalColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.fillSuperView(.Both)
        
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.0
        layer.borderColor = DropdownMenuConfiguration.separatorColor.CGColor
    }
    
    // MARK: Properties
    
    override var selected: Bool {
        didSet {
            if selected {
                layer.borderColor = DropdownMenuConfiguration.highlightColor.CGColor
                titleLabel.textColor = DropdownMenuConfiguration.highlightColor
            } else {
                layer.borderColor = DropdownMenuConfiguration.separatorColor.CGColor
                titleLabel.textColor = DropdownMenuConfiguration.normalColor
            }
        }
    }
}

// MARK: - Section Header

protocol DropdownCollectionViewSectionHeaderDelegate: class {
    func toggleSectionContentHiddenState(state: Bool)
}

class DropdownCollectionViewSectionHeader: UICollectionReusableView {
    // MARK: Properties
    private var expandState = false
    weak var delegate: DropdownCollectionViewSectionHeaderDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = DropdownMenuConfiguration.normalColor
        label.font = DropdownMenuConfiguration.collectionViewSubmenuHeaderFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let expandButton: UIButton = {
        let button = UIButton(type: .Custom)
        button.setImage(DropdownMenuConfiguration.triangleImage, forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var reuseIdentifier: String {
        return DropdownMenuConfiguration.headerIdentifier
    }

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        expandButton.addTarget(self, action: "toggleExpandState", forControlEvents: .TouchUpInside)
        
        addSubview(titleLabel)
        addSubview(expandButton)
        
        titleLabel.positionToSuperView(horizontal: .Left, hOffset: 15.0, vertical: .Center, vOffset: 0)
        expandButton.positionToSuperView(horizontal: .Right, hOffset: -15.0, vertical: .Center, vOffset: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Convenience
    
    func toggleExpandState() {
        expandState = !expandState
        if expandState {
            expandButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            expandButton.tintColor = DropdownMenuConfiguration.highlightColor
        } else {
            expandButton.transform = CGAffineTransformMakeRotation(0)
            expandButton.tintColor = DropdownMenuConfiguration.normalColor
        }
        delegate?.toggleSectionContentHiddenState(expandState)
    }
}

// MARK: - Footer

// MARK: DecorationFooter

class DropdownCollectionViewSectionDecorationFooter: UICollectionReusableView {
    // MARK: Properties
    
    let decorationView: UIView = {
        let view = UIView()
        view.backgroundColor = DropdownMenuConfiguration.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var reuseIdentifier: String {
        return DropdownMenuConfiguration.decorationFooterIdentifier
    }

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(decorationView)
        decorationView.addDimentionConstraints(.Height, constant: 1.0)
        decorationView.positionToSuperView(horizontal: .Left, hOffset: 15.0, vertical: .Bottom, vOffset: -1)
        decorationView.positionToSuperView(horizontal: .Right, hOffset: -15.0, vertical: .Bottom, vOffset: -1)
    }
}

// MARK: DoneFooter

protocol DropdownCollectionViewSectionDoneFooterDelegate: class {
    func submenuSelectionFinished()
}

class DropdownCollectionViewSectionDoneFooter: UICollectionReusableView {
    // MARK: Properties
    
    weak var delegate: DropdownCollectionViewSectionDoneFooterDelegate?
    
    let doneButton: UIButton  = {
        let button = UIButton(type: .Custom)
        button.setTitle(NSLocalizedString("完成", comment:  ""), forState: .Normal)
        button.setTitleColor(DropdownMenuConfiguration.highlightColor, forState: .Normal)
        button.titleLabel?.font = DropdownMenuConfiguration.collectionViewSubmenuFinishButtonFont
        
        button.layer.borderColor = DropdownMenuConfiguration.highlightColor.CGColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 4.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override var reuseIdentifier: String {
        return DropdownMenuConfiguration.doneFooterIdentifier
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.addTarget(self, action: "select", forControlEvents: .TouchUpInside)
        addSubview(doneButton)
        
        doneButton.addDimentionConstraints(.Height, constant: 40.0)
        doneButton.positionToSuperView(horizontal: .Left, hOffset: 15.0, vertical: .Top, vOffset: 40.0)
        doneButton.positionToSuperView(horizontal: .Right, hOffset: -15.0, vertical: .Top, vOffset: 40.0)
    }
    
    // MARK: Convience

    func select() {
        delegate?.submenuSelectionFinished()
    }
}

// MARK: - CollectionViewSubmenuSubmenu

class DropdownCollectionViewSubmenu: UICollectionView {
    // MARK: Initializers

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.whiteColor()
        
        registerClass(DropdownCollectionViewCell.self, forCellWithReuseIdentifier: DropdownMenuConfiguration.cellIdentifier)
        registerClass(DropdownCollectionViewSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: DropdownMenuConfiguration.headerIdentifier)
        registerClass(DropdownCollectionViewSectionDecorationFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: DropdownMenuConfiguration.decorationFooterIdentifier)
        registerClass(DropdownCollectionViewSectionDoneFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: DropdownMenuConfiguration.doneFooterIdentifier)
    }
}

// MARK: DropdownSubmenu

extension DropdownCollectionViewSubmenu: DropdownSubmenu  {
    
    func reload(includeMainMenu: Bool = false) {
        reloadData()
    }
    
    var title: String? {
        return nil
    }
    
    override func intrinsicContentSize() -> CGSize {
        return contentSize
    }
    
    func selectItemAtIndex(index: DropdownSubmenuIndex) {
        if let mainIndex = index.mainSubmenuIndex {
            selectItemAtIndexPath(NSIndexPath(forRow: mainIndex, inSection: 0), animated: false, scrollPosition: .Top)
        } else if let secondaryIndex = index.secondarySubmenuIndex {
            selectItemAtIndexPath(NSIndexPath(forRow: secondaryIndex, inSection: 1), animated: false, scrollPosition: .Top)
        }
    }
}