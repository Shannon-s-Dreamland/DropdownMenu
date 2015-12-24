//
//  ColorManager.swift
//  Client
//
//  Created by Shannon Wu on 10/22/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

#if os(iOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

struct ColorManager {

    static var title: AppColor {
        return AppColor(hex: 0x222c38)
    }
    
    static var content: AppColor {
        return AppColor(hex: 0x5a626d)
    }
    
    static var prompt: AppColor {
        return AppColor(hex: 0x969fa9)
    }
    
    static var divider: AppColor {
        return AppColor(hex: 0xe7e7e7)
    }
    
    static var background: AppColor {
        return AppColor(hex: 0xf9f9f9)
    }
    
    static var theme: AppColor {
        return AppColor(hex: 0x4285f4)
    }

    static var auxiliary: AppColor {
        return AppColor(hex: 0xff6e0e)
    }
    
    static var success: AppColor {
        return AppColor(hex: 0x31c27c)
    }
    
    static var failure: AppColor {
        return AppColor(hex: 0xf0633d)
    }
    
    static var empty: AppColor {
        return AppColor(hex: 0xcccccc)
    }
    
    static var lightBackground: AppColor {
        return AppColor(hex: 0xfafafa)
    }
    
    static var greenHighlight: AppColor {
        return AppColor(hex: 0x3da300)
    }
}
