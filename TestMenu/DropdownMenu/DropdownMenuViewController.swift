//
//  DiscoveryMenuViewController.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/18/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: - Menu View Controller

class DropdownMenuViewController: UIViewController {
    // MARK: Types
    
    enum SubmenuType {
        case TableViewSingleView
        case TableViewDoubleView
        case CollectionView
    }

    // MARK: Properties
    
    weak var menuManager: DropdownMenuManager?
    var currentlySelectedSubmenu: DropdownSubmenu?
    var mainMenu: DropdownMenu!
    var backgroundView: UIView?
    var collectionViewHeaders = [DropdownCollectionViewSectionHeader]()
    
    var submenuType: SubmenuType? {
        willSet {
            if let submenuType = submenuType {
                switch submenuType {
                case .TableViewSingleView:
                    tableViewSubmenuSinlgeView.removeFromSuperview()
                case .TableViewDoubleView:
                    tableViewSubmenuDoubleView.removeFromSuperview()
                case .CollectionView:
                    collectionViewSubmenuView.removeFromSuperview()
                }
            }
        }
        
        didSet {
            if let submenuType = submenuType {
                switch submenuType {
                case .TableViewSingleView:
                    view.addSubview(tableViewSubmenuSinlgeView)
                    currentlySelectedSubmenu = tableViewSubmenuSinlgeView
                    tableViewSubmenuSinlgeView.reload()
                case .TableViewDoubleView:
                    view.addSubview(tableViewSubmenuDoubleView)
                    currentlySelectedSubmenu = tableViewSubmenuDoubleView
                    tableViewSubmenuDoubleView.reload()
                case .CollectionView:
                    view.addSubview(collectionViewSubmenuView)
                    currentlySelectedSubmenu = collectionViewSubmenuView
                    collectionViewSubmenuView.reload()
                }
            }
            animateShowSubmenu()
        }
    }

    lazy var tableViewSubmenuSinlgeView: DropdownTableViewSubmenuSinlgeView = {
        let submenu = DropdownTableViewSubmenuSinlgeView()
        submenu.delegate = self
        submenu.dataSource = self
        return submenu
    }()
    
    lazy var tableViewSubmenuDoubleView: DropdownTableViewSubmenuDoubleView = {
        let submenu = DropdownTableViewSubmenuDoubleView()
        submenu.delegate = self
        submenu.dataSource = self
        return submenu
    }()
    
    lazy var collectionViewSubmenuView: DropdownCollectionViewSubmenu = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumLineSpacing = DropdownMenuConfiguration.collectionViewSubmenuMinimumLineSpacing
        layout.minimumInteritemSpacing = DropdownMenuConfiguration.collectionViewSubmenuMinimumInteritemSpacing
        layout.itemSize = DropdownMenuConfiguration.collectionViewSubmenuItemSize
        layout.sectionInset = DropdownMenuConfiguration.collectionViewSubmenuEdgeInsets
        layout.headerReferenceSize = DropdownMenuConfiguration.collectionViewSubmenuHeaderReferenceSize
        let submenu = DropdownCollectionViewSubmenu(frame: CGRect.zero, collectionViewLayout: layout)
        submenu.allowsMultipleSelection = true
        submenu.delegate = self
        submenu.dataSource = self
        return submenu
    }()
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure background view
        backgroundView = UIView()
        backgroundView!.translatesAutoresizingMaskIntoConstraints = false
        backgroundView!.backgroundColor = DropdownMenuConfiguration.backgroundViewColor
        backgroundView!.alpha = DropdownMenuConfiguration.backgroundViewAlpha
        view.addSubview(backgroundView!)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "animateHideSubmenu")
        backgroundView?.addGestureRecognizer(tapGesture)
        
        backgroundView!.fillSuperView(.Both)

        // Configure menu manager
        guard let menuManager = menuManager else { return }
        mainMenu = DropdownMenu(items: menuManager.intialTitlesForMainMenu(), delegate: menuManager)
        mainMenu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainMenu)
        
        mainMenu.addDimentionConstraints(.Height, constant: DropdownMenuConfiguration.mainMenuHeight)
        mainMenu.pinToSuperView(.Top, inset: 0, relation: .Equal)
        
        // Configure view
        view.frame = DropdownMenuConfiguration.mainMenuFrame
    }
    
    //MARK: Convenience + Menu Frame

    func animateShowSubmenu() {
        guard let submenuType = submenuType else {
            assertionFailure("在没有设置 Submenu 的时候调用到这里")
            return
        }
        
        let submenu: UIView
        switch submenuType {
        case .TableViewSingleView:
            submenu = tableViewSubmenuSinlgeView
        case .TableViewDoubleView:
            submenu = tableViewSubmenuDoubleView
        case .CollectionView:
            submenu = collectionViewSubmenuView
        }
        
        if let superView = view.superview {
            view.frame.size = CGSize(width: superView.bounds.width, height: superView.bounds.height - DropdownMenuConfiguration.mainMenuTopOffset)
        }
        
        submenu.positionRelativeToView(mainMenu, direction: .Bottom, space: 0.0)
        submenu.pinToSuperView(.Bottom, inset: DropdownMenuConfiguration.backgroundViewMinimumHeight, relation: .GreaterThanOrEqual)
    }
    
    func animateHideSubmenu() {
        currentlySelectedSubmenu?.removeFromSuperview()
        view.frame = DropdownMenuConfiguration.mainMenuFrame
        
        mainMenu.setTitleForSelectedItem(currentlySelectedSubmenu?.title)
        menuManager?.resetSelectionState()
        menuManager?.reloadData()
    }
    
    //MARK: Convenience + Menu State

    func reloadSubmenu(includeMainMenu: Bool = false) {
        if let submenuType = submenuType {
            switch submenuType {
            case .TableViewSingleView:
                tableViewSubmenuSinlgeView.reload(includeMainMenu)
            case .TableViewDoubleView:
                tableViewSubmenuDoubleView.reload(includeMainMenu)
            case .CollectionView:
                collectionViewSubmenuView.reload(includeMainMenu)
            }
        }
    }
    
    func setTitleForMainMenu(title: String) {
        mainMenu.setTitleForSelectedItem(title)
    }
    
    func selectItemAtIndex(index: DropdownSubmenuIndex) {
        currentlySelectedSubmenu?.selectItemAtIndex(index)
    }
    
}
