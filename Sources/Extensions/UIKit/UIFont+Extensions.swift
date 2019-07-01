//
//  UIFont+Extensions.swift
//  StreamChat
//
//  Created by Alexey Bukhtin on 03/04/2019.
//  Copyright © 2019 Stream.io Inc. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
    public static let chatRegular = UIFont.systemFont(ofSize: 15)
    public static let chatRegularBold = UIFont.systemFont(ofSize: 15, weight: .bold)
    public static let chatXRegularMedium = UIFont.systemFont(ofSize: 14, weight: .medium)
    public static let chatMedium = UIFont.systemFont(ofSize: 13)
    public static let chatMediumBold = UIFont.systemFont(ofSize: 13, weight: .bold)
    public static let chatMediumMedium = UIFont.systemFont(ofSize: 13, weight: .medium)
    public static let chatMediumItalic = UIFont.systemFont(ofSize: 13).withTraits(.traitItalic)
    public static let chatSmall = UIFont.systemFont(ofSize: 11)
    public static let chatSmallMedium = UIFont.systemFont(ofSize: 11, weight: .medium)
    public static let chatSmallBold = UIFont.systemFont(ofSize: 11, weight: .bold)
    public static let chatXSmall = UIFont.systemFont(ofSize: 10)
    public static let chatXSmallBold = UIFont.systemFont(ofSize: 10, weight: .bold)
    public static let chatXXSmall = UIFont.systemFont(ofSize: 9)
    public static let chatEmoji = UIFont.systemFont(ofSize: 26)
    public static let reactionsEmoji = UIFont.systemFont(ofSize: 22)
    
    public static func avatarFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "GillSans-UltraBold", size: size)
    }
    
    public static func monospaced(size: CGFloat) -> UIFont? {
        return UIFont(name: "Menlo-Regular", size: size)
    }
}

extension UIFont {
    public func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        if let descriptor = fontDescriptor.withSymbolicTraits(traits) {
            return UIFont(descriptor: descriptor, size: 0) // size 0 means keep the size as it is
        }
        
        return self
    }
}
