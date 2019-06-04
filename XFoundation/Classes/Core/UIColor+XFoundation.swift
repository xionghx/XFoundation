//
//  UIColor+AppKit.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import UIKit

public extension UIColor {
    /// 自定义初始化颜色
    ///
    /// - Parameter string: 颜色 hex 值
	convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        self.init(
            red: CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue: CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: alpha)
    }
}

public extension XFoundation where Base: UIColor {

    // MARK: - New

    /// rgb: #0E1C38
	static var navigationBar: UIColor {
        return UIColor.init(hex: "#121A45")
    }

    // MARK: - 已废弃

    /// rgb: #1ca2f3
	static var blue: UIColor {
        return UIColor.init(hex: "#1ca2f3")
    }

    /// rgb: #fe6458
	static var red: UIColor {
        return UIColor.init(hex: "#fe6458")
    }

    /// rgb: #222222
	static var darkGray: UIColor {
        return UIColor.init(hex: "#222222")
    }

    /// rgb: #666666
	static var gray: UIColor {
        return UIColor.init(hex: "#666666")
    }

    /// rgb: #999999
	static var lightGray: UIColor {
        return UIColor.init(hex: "#999999")
    }

    /// rgb: #f2f2f2
	static var lightGray1: UIColor {
        return UIColor.init(hex: "#f2f2f2")
    }

    /// rgb: #d7d7d7
	static var separator: UIColor {
        return UIColor.init(hex: "#d7d7d7")
    }

}
