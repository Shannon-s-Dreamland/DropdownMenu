//
//  AppColor+Utils.swift
//  Client
//
//  Created by Shannon Wu on 10/21/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

#if os(iOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

#if os(iOS) || os(watchOS)
    /// AppColor 是 UIColor 的别名.
    typealias AppColor = UIColor
#elseif os(OSX)
    /// AppColor 是 NSColor 的别名.
    typealias AppColor = NSColor
#endif

// MARK: - 扩展 UIColor 或者 NSColor, 包含一些常量和初始化方法.
extension AppColor {

    /// 返回一个随机的 UIColor 或者 NSColor.
    static var randomColor: AppColor {
        let r = CGFloat(drand48())
        let g = CGFloat(drand48())
        let b = CGFloat(drand48())

        return AppColor(red: r, green: g, blue: b, alpha: 1.0)
    }

    /**
    通过颜色值的 Hex 字符串和 默认为1.0的 Alpha 值来初始化一个 UIColor 或者 NSColor.

    - parameter hexString: 颜色值的 Hex 字符串, 传入的字符串可以为 `FFFFFF`
    或者 `#FFFFFF` 的形式.
    - parameter alpha:     颜色值的 alpha 值, 默认为 1.0

    - returns: 如果传入的 Hex 字符串有效, 则返回一个初始化成功的UIColor 或者 NSColor;
    如果传入的 Hex 字符串无效, 则返回 nil.
    */
    convenience init?(hexString: String, alpha: CGFloat = 1.0){
        var result: UInt32 = 0

        let scanner = NSScanner(string: hexString)
        if hexString.characters.first == "#" {
            scanner.scanLocation = 1
        } else {
            scanner.scanLocation = 0
        }

        if !scanner.scanHexInt(&result) { return nil }

        self.init(hex: result, alpha: alpha)
    }

    /**
    通过颜色值的 Hex 值和默认为1.0的 Alpha 值来初始化一个 UIColor 或者 NSColor.

    - parameter hex:   颜色值的 Hex值, 传入 UInt32类型的值.
    - parameter alpha: 颜色值的 alpha 值, 默认为 1.0

    - returns: 返回一个初始化成功的UIColor 或者 NSColor
    */
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = CGFloat(((hex & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((hex & 0xFF00) >> 8)) / 255.0
        let b = CGFloat(((hex & 0xFF))) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

}
