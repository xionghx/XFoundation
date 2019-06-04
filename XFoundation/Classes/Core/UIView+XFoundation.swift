//
//  UIView+AppKit.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import UIKit

// MARK: - Layer

public extension UIView {

    @IBInspectable
	var LayerCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }

    @IBInspectable
	var LayerBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
	var LayerBorderColor: UIColor {
        get {
            return UIColor.black
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }

    @IBInspectable
	var LayerMasksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
}

// MARK: - Frame

public extension XFoundation where Base: UIView {

	var left: CGFloat {
        set {
            self.base.frame.origin.x = newValue
        }
        get {
            return self.base.frame.minX
        }
    }

	var top: CGFloat {
        set {
            self.base.frame.origin.y = newValue
        }
        get {
            return self.base.frame.minY
        }
    }

	var right: CGFloat {
        set {
            self.base.frame.origin.x = newValue - self.base.frame.size.width
        }
        get {
            return self.base.frame.maxX
        }
    }

	var bottom: CGFloat {
        set {
            self.base.frame.origin.y = newValue - self.base.frame.size.height
        }
        get {
            return self.base.frame.maxY
        }
    }

	var centerX: CGFloat {
        set {
            self.base.center.x = newValue
        }
        get {
            return self.base.center.x
        }
    }

	var centerY: CGFloat {
        set {
            self.base.center.y = newValue
        }
        get {
            return self.base.center.y
        }
    }

	var height: CGFloat {
        set {
            self.base.frame.size.height = newValue
        }
        get {
            return self.base.frame.size.height
        }
    }

	var width: CGFloat {
        set {
            self.base.frame.size.width = newValue
        }
        get {
            return self.base.frame.size.width
        }
    }

}

// MARK: - Corner

public extension UIView {
    /// 设置视图部分圆角
    ///
    /// - Parameters:
    ///   - rect: 视图位置大小
    ///   - corners: 圆角的位置类型
    ///   - cornerRadii: 圆角半径
	func setCorner(roundedRect rect: CGRect,
                          byRoundingCorners corners: UIRectCorner,
                          cornerRadii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
