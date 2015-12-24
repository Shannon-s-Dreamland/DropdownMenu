//
//  DropdownSubmenu.swift
//  Client
//
//  Created by Shannon Wu on 12/22/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import Foundation

// MARK: - Submenu
protocol DropdownSubmenu: class {
    var title: String? { get }

    func reload(includeMainMenu: Bool)
    func removeFromSuperview()
    func selectItemAtIndex(index: DropdownSubmenuIndex)
}
