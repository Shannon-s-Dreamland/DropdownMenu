//
//  DropdownMenuViewController+TableView.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/20/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

// MARK: DropdownMenu + UITableViewDelegate

extension DropdownMenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return DropdownMenuConfiguration.tableViewCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let submenuType = submenuType else {
            assertionFailure("在没有设置 SubMenu 的时候, 不应该调到这个方法")
            return
        }
        
        switch submenuType {
        case .TableViewSingleView:
            menuManager?.didSelectSubmenuAtIndex(DropdownSubmenuIndex(mainSubmenuIndex: indexPath.row, secondarySubmenuIndex: nil))
            animateHideSubmenu()
        case .TableViewDoubleView:
            if let type = DropdownTableViewSubmenuDoubleViewType(rawValue: tableView.tag) {
                switch type {
                case .Main:
                    menuManager?.didSelectSubmenuAtIndex(DropdownSubmenuIndex(mainSubmenuIndex: indexPath.row, secondarySubmenuIndex: nil))
                case .Secondary:
                    menuManager?.didSelectSubmenuAtIndex(DropdownSubmenuIndex(mainSubmenuIndex: nil, secondarySubmenuIndex: indexPath.row))
                    animateHideSubmenu()
                }
            }
        case .CollectionView:
            assertionFailure("不应该请求到 CollectionView")
        }
    }
}

// MARK: DropdownMenu + UITableViewDataSource

extension DropdownMenuViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let submenuType = submenuType else {
            assertionFailure("在没有设置 SubMenu 的时候, 不应该调到这个方法")
            return 0
        }
        
        switch submenuType {
        case .TableViewSingleView:
            return menuManager?.numberOfSectionsInSubmenu(true) ?? 0
        case .TableViewDoubleView:
            if let type = DropdownTableViewSubmenuDoubleViewType(rawValue: tableView.tag) {
                switch type {
                case .Main:
                    return menuManager?.numberOfSectionsInSubmenu(true) ?? 0
                case .Secondary:
                    return menuManager?.numberOfSectionsInSubmenu(false) ?? 0
                }
            }
            assertionFailure("必须要获取到 Type")
            return 0
        case .CollectionView:
            assertionFailure("不应该请求到 CollectionView")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let submenuType = submenuType else {
            assertionFailure("在没有设置 SubMenu 的时候, 不应该调到这个方法")
            return 0
        }
        switch submenuType {
        case .TableViewSingleView:
            return menuManager?.numberOfRowsInSection(section, isMainSubmenu: true) ?? 0
        case .TableViewDoubleView:
            if let type = DropdownTableViewSubmenuDoubleViewType(rawValue: tableView.tag) {
                switch type {
                case .Main:
                    return menuManager?.numberOfRowsInSection(section, isMainSubmenu: true) ?? 0
                case .Secondary:
                    return menuManager?.numberOfRowsInSection(section, isMainSubmenu: false) ?? 0
                }
            }
            assertionFailure("必须要获取到 Type")
            return 0
        default:
            assertionFailure("不应该请求到 CollectionView")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let submenuType = submenuType else {
            assertionFailure("在没有设置 SubMenu 的时候, 不应该调到这个方法")
            return UITableViewCell()
        }
        switch submenuType {
        case .TableViewSingleView:
            if let cell = tableView.dequeueReusableCellWithIdentifier(DropdownMenuConfiguration.cellIdentifier) as? DropdownTableViewSubmenuSinlgeViewCell {
                cell.titleLabel.text = menuManager?.titleForDropdownSubmenuIndex(DropdownSubmenuIndex(mainSubmenuIndex: indexPath.row, secondarySubmenuIndex: nil))
                return cell
            }
        case .TableViewDoubleView:
            if let type = DropdownTableViewSubmenuDoubleViewType(rawValue: tableView.tag) {
                switch type {
                case .Main:
                    if let cell = tableView.dequeueReusableCellWithIdentifier(DropdownMenuConfiguration.cellIdentifier) as? DropdownSubmenuMainViewCell {
                        cell.titleLabel.text = menuManager?.titleForDropdownSubmenuIndex(DropdownSubmenuIndex(mainSubmenuIndex: indexPath.row, secondarySubmenuIndex: nil))
                        return cell
                    }
                case .Secondary:
                    if let cell = tableView.dequeueReusableCellWithIdentifier(DropdownMenuConfiguration.cellIdentifier) as? DropdownSubmenuSecondaryViewCell {
                        cell.titleLabel.text = menuManager?.titleForDropdownSubmenuIndex(DropdownSubmenuIndex(mainSubmenuIndex: nil, secondarySubmenuIndex: indexPath.row))
                        return cell
                    }
                }
            } else {
                assertionFailure("必须要获取到 Type")
            }
        case .CollectionView:
            assertionFailure("不应该请求到 CollectionView")
        }
        assertionFailure("没有获取到正确的 Cell")
        return UITableViewCell()
    }
}
