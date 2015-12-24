//
//  DemoDropdownMenuManager.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/19/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import Foundation

class DemoDropdownMenuManager: DropdownMenuManager {
    
    weak var menuVC: DropdownMenuViewController?
    
    private var currentlySelectedIndex: Int?
    
    var shrinkStateItemCount: Int {
        return 12
    }
    
    func intialTitlesForMainMenu() -> [String] {
        return ["你好", "我不好", "你好不好", "好!"]
    }
    
    func mainMenuItemAtIndexSelected(index: Int) {
        if index == currentlySelectedIndex {
            menuVC?.animateHideSubmenu()
            resetSelectionState()
            return
        }
        currentlySelectedIndex = index
        if index == 0 {
            menuVC?.submenuType = .TableViewSingleView
        }
        else if index == 1 {
            menuVC?.submenuType = .TableViewDoubleView
        } else if index == 2{
            menuVC?.submenuType = .CollectionView
        } else {
            menuVC?.submenuType = .TableViewSingleView
        }
    }
    
    func resetSelectionState() {
        currentlySelectedIndex = nil
    }
    
    func didSelectSubmenuAtIndex(index: DropdownSubmenuIndex) {
        print("\(index.main) \(index.secondary)")
    }
    
    func numberOfSectionsInSubmenu(isMainSubmenu: Bool) -> Int {
        return 2
    }
    
    func numberOfRowsInSection(section: Int, isMainSubmenu: Bool) -> Int {
        return 5
    }
    
    func titleForDropdownSubmenuIndex(index: DropdownSubmenuIndex) -> String? {
        return "现在好点了"
    }
    
    func titleForSectionInSubmenu(section: Int) -> String? {
        return "好多了@"
    }
    
    func toggleOpenState(state: Bool) {}
    
    func reloadData() {}
}
