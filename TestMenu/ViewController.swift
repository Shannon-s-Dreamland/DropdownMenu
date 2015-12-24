//
//  ViewController.swift
//  TestMenu
//
//  Created by Shannon Wu on 12/18/15.
//  Copyright © 2015 Shannon's Dreamland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let menuViewController = DropdownMenuViewController()
    let menuManager = DemoDropdownMenuManager()
    
    override func viewDidLoad() {
        menuViewController.menuManager = menuManager
        menuManager.menuVC = menuViewController
        
        view.addSubview(menuViewController.view)
    }
}

