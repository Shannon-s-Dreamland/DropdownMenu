//
//  DropdownMenuConfiguration.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/20/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: - Menu Item

struct DropdownMenuConfiguration {
    // MARK: Main Menu
    static let mainMenuFrame = CGRect(x: 0, y: 64.0, width: UIScreen.mainScreen().bounds.width, height: 50.0)
    static let mainMenuHeight: CGFloat = 50.0
    static let mainMenuBackgoundColor = UIColor.whiteColor()
    static let mainMenuBorderWidth: CGFloat = 1.0
    static let mainMenuBorderColor = ColorManager.divider
    static let mainMenuFont = FontManager.caption2
    static let mainMenuTopOffset: CGFloat = 64.0
    
    // MARK: Submenu
    static let mainSubmenuBackgroundColor = ColorManager.lightBackground
    
    // MARK: TableViewSubmenu
    static let tableViewMainSubMenuLeftOffSet: CGFloat = 44.0
    static let tableViewSecondarySubMenuLeftOffSet: CGFloat = 30.0
    
    // MARK: CollectionViewSubmenu
    static let collectionViewSubmenuBodyFont = FontManager.body
    static let collectionViewSubmenuHeaderFont = FontManager.caption1
    static let collectionViewSubmenuSideMargin: CGFloat = 15.0
    static let collectionViewSubmenuTopMargin: CGFloat = 13.0
    static let collectionViewSubmenuFinishButtonFont = FontManager.caption1
    static let collectionViewSubmenuHeaderReferenceSize = CGSize(width: 0, height: 45.0)
    static let collectionViewSubmenuEdgeInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    static let collectionViewSubmenuItemSize = CGSize(width: 80.0, height: 33.0)
    static let collectionViewSubmenuMinimumInteritemSpacing: CGFloat = 12.0
    static let collectionViewSubmenuMinimumLineSpacing: CGFloat = 15.0
    static let collectionViewSubmenuFirstSectionSize = CGSize(width: 0, height: 15.0)
    static let collectionViewSubmenuSecondSectionSize = CGSize(width: 0, height: 108.0)

    // MARK: Identifier
    static let cellIdentifier = "Cell"
    static let headerIdentifier = "Header"
    static let decorationFooterIdentifier = "DecorationFooter"
    static let doneFooterIdentifier = "DoneIdentifier"

    // MARK: Overall
    static let normalColor = ColorManager.content
    static let highlightColor = ColorManager.theme
    static let separatorColor = ColorManager.divider
    static let headerFont = FontManager.caption1
    static let triangleImage = UIImage(named: "dropdown_menu_triangle")
    
    static let secondarySubmenuBackgroundColor = UIColor.whiteColor()
    static let space: CGFloat = 3.0
    static let tableViewCellHeight: CGFloat = 50.0
    
    // MARK: Background
    static let backgroundViewColor = UIColor.blackColor()
    static let backgroundViewAlpha: CGFloat = 0.3
    static let backgroundViewMinimumHeight: CGFloat = 120.0
}
