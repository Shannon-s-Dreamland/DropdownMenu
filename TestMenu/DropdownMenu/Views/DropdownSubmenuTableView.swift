//
//  DropdownSubmenuTableView.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/20/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: - Base Cell
class DropdownSubmenuBaseCell: UITableViewCell {
    // MARK: Properties

    let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = DropdownMenuConfiguration.headerFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        selectionStyle = .None
    }
}

// MARK: - Main View Cell

class DropdownSubmenuMainViewCell: DropdownSubmenuBaseCell {
    // MARK: Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(titleLabel)
        titleLabel.positionToSuperView(horizontal: .Left, hOffset: DropdownMenuConfiguration.tableViewMainSubMenuLeftOffSet, vertical: .Center, vOffset: 0.0)
        
        borders = addBorder(edges: [.Right, .Bottom], colour: DropdownMenuConfiguration.separatorColor, thickness: 1.0)
        backgroundColor = DropdownMenuConfiguration.mainSubmenuBackgroundColor
        
    }
    
    // MARK: Properties
    var borders: [UIRectEdge: UIView]?
    
    // MARK: Conviences

    override func setSelected(selected: Bool, animated: Bool) {
        if selected {
            if let border = borders?[.Right] {
                border.backgroundColor = UIColor.whiteColor()
                border.setNeedsDisplay()
            }
            backgroundColor = UIColor.whiteColor()
            titleLabel.textColor = DropdownMenuConfiguration.highlightColor
        } else {
            if let border = borders?[.Right] {
                border.backgroundColor = DropdownMenuConfiguration.separatorColor
                border.setNeedsDisplay()
            }
            backgroundColor =  DropdownMenuConfiguration.mainSubmenuBackgroundColor
            titleLabel.textColor = DropdownMenuConfiguration.normalColor
        }
    }

}


// MARK: - Secondary View Cell + Single View Cell

typealias DropdownTableViewSubmenuSinlgeViewCell = DropdownSubmenuSecondaryViewCell

class DropdownSubmenuSecondaryViewCell: DropdownSubmenuBaseCell {
    // MARK: Initializers

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
        
        addSubview(titleLabel)
        
        titleLabel.positionToSuperView(horizontal: .Left, hOffset: DropdownMenuConfiguration.tableViewSecondarySubMenuLeftOffSet, vertical: .Center, vOffset: 0.0)

        backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: Properties
    
    override func setSelected(selected: Bool, animated: Bool) {
        if selected {
            titleLabel.textColor = DropdownMenuConfiguration.highlightColor
        } else {
            titleLabel.textColor = DropdownMenuConfiguration.normalColor
        }
    }
}

// MARK: - Submenu Base View

class DropdownTableSubmenuBaseView: UITableView {
    // MARK: Initializers

    init() {
        super.init(frame: CGRect.zero, style: .Plain)
        translatesAutoresizingMaskIntoConstraints = false
        
        let footer = UIView()
        tableFooterView = footer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Submenu Main View

class DropdownTableSubmenuMainView: DropdownTableSubmenuBaseView {
    // MARK: Initializers

    override init() {
        super.init()
        
        registerClass(DropdownSubmenuMainViewCell.self, forCellReuseIdentifier: DropdownMenuConfiguration.cellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DropdownTableSubmenuSecondaryView: DropdownTableSubmenuBaseView {
    // MARK: Initializers

    override init() {
        super.init()
        
        separatorStyle = .None
        registerClass(DropdownSubmenuSecondaryViewCell.self, forCellReuseIdentifier: DropdownMenuConfiguration.cellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Submenu Single View + Single View

typealias DropdownTableViewSubmenuSinlgeView = DropdownTableSubmenuSecondaryView

// MARK: SubmenuSinlgeView+DropdownSubmenu

extension DropdownTableViewSubmenuSinlgeView: DropdownSubmenu {
    var title: String? {
        if let indexPath = indexPathForSelectedRow,
            cell = cellForRowAtIndexPath(indexPath) as? DropdownSubmenuBaseCell {
                return cell.titleLabel.text
        }
        return nil
    }
    
    override func intrinsicContentSize() -> CGSize {
        return contentSize
    }
    
    func reload(includeMainMenu: Bool = true) {
        reloadData()
    }
    
    func selectItemAtIndex(index: DropdownSubmenuIndex) {
        if let mainIndex = index.main {
            selectRowAtIndexPath(NSIndexPath(forRow: mainIndex, inSection: 0), animated: false, scrollPosition: .Top)
        }
    }
}

// MARK: - SubmenuDoubleView

enum DropdownTableViewSubmenuDoubleViewType: Int {
    case Main = 0
    case Secondary = 1
}

class DropdownTableViewSubmenuDoubleView: UIView{
    // MARK: Properties
    
    let mainView: DropdownTableSubmenuMainView = {
        let mainView = DropdownTableSubmenuMainView()
        return mainView
    }()
    
    let secondaryView: DropdownTableSubmenuSecondaryView = {
        let secondaryView = DropdownTableSubmenuSecondaryView()
        return secondaryView
    }()
    
    weak var delegate: UITableViewDelegate? {
        didSet {
            mainView.delegate = delegate
            secondaryView.delegate = delegate
        }
    }
    
    weak var dataSource: UITableViewDataSource? {
        didSet {
            mainView.dataSource = dataSource
            secondaryView.dataSource = dataSource
        }
    }
    
    // MARK: Initializers

    init() {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        addSubview(mainView)
        addSubview(secondaryView)
        
        mainView.tag = DropdownTableViewSubmenuDoubleViewType.Main.rawValue
        secondaryView.tag = DropdownTableViewSubmenuDoubleViewType.Secondary.rawValue
        
        mainView.fillSuperView(.Vertical)
        secondaryView.fillSuperView(.Vertical)
        LayoutKit.arrangeViews(.Horizontal, viewsTuple: [(mainView, 1.0), (secondaryView, 2)])
    }
}

// MARK: DropdownTableViewSubmenuDoubleView + DropdownSubmenu

extension DropdownTableViewSubmenuDoubleView: DropdownSubmenu  {
    var title: String? {
        if let indexPath = secondaryView.indexPathForSelectedRow,
            cell = secondaryView.cellForRowAtIndexPath(indexPath) as? DropdownSubmenuBaseCell {
                return cell.titleLabel.text
        }
        return nil
    }
    
    override func intrinsicContentSize() -> CGSize {
        return mainView.contentSize.height > secondaryView.contentSize.height ? mainView.contentSize : secondaryView.contentSize
    }
    
    func selectItemAtIndex(index: DropdownSubmenuIndex) {
        if let mainIndex = index.main {
            mainView.selectRowAtIndexPath(NSIndexPath(forRow: mainIndex, inSection: 0), animated: false, scrollPosition: .None)
        }
        if let secondaryIndex = index.secondary {
            secondaryView.selectRowAtIndexPath(NSIndexPath(forRow: secondaryIndex, inSection: 0), animated: false, scrollPosition: .None)
        }
    }
    
    func reload(includeMainMenu: Bool = false) {
        if includeMainMenu {
            mainView.reloadData()
        }
        secondaryView.reloadData()
    }
}
