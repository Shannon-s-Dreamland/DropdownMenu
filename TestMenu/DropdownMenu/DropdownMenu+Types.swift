//
//  DropdownMenuManager.swift
//  Client
//
//  Created by Shannon Wu on 12/23/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import UIKit

// MARK: - Menu Manager

protocol DropdownMenuManager: DropdownMenuDelegate {
    
    // Main Menu
    func intialTitlesForMainMenu() -> [String]
    
    // Submenu
    func numberOfSectionsInSubmenu(isMainSubmenu: Bool) -> Int
    func titleForSectionInSubmenu(section: Int) -> String?
    
    func numberOfRowsInSection(section: Int, isMainSubmenu: Bool) -> Int
    func titleForDropdownSubmenuIndex(index: DropdownSubmenuIndex) -> String?
    
    func didSelectSubmenuAtIndex(index: DropdownSubmenuIndex)
    
    var shrinkStateItemCount: Int { get }
    
    // Reload Data
    func reloadData()
    
    // Toggle Open
    func toggleOpenState(state: Bool)
}

// MARK: - Submenu Index

struct DropdownSubmenuIndex {
    let mainSubmenuIndex: Int?
    let secondarySubmenuIndex: Int?
}
