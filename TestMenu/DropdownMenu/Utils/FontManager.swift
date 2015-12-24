//
//  FontManager.swift
//  Client
//
//  Created by Shannon Wu on 10/26/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

#if os(iOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

#if os(iOS) || os(watchOS)
typealias AppFont = UIFont
#elseif os(OSX)
typealias AppFont = NSFont
#endif

struct FontManager {
    
    static var headline: AppFont {
        return AppFont.systemFontOfSize(18)
    }
    
    static var subheadline: AppFont {
        return AppFont.systemFontOfSize(17)
    }
    
    static var boldSubheadline: AppFont {
        return AppFont.boldSystemFontOfSize(17)
    }
    
    static var caption1: AppFont {
        return AppFont.systemFontOfSize(15)
    }
    
    static var body: AppFont {
        return AppFont.systemFontOfSize(14)
    }
    
    static var caption2: AppFont {
        return AppFont.systemFontOfSize(13)
    }
    
    static var footnote: AppFont {
        return AppFont.systemFontOfSize(11)
    }
    
}
