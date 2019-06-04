//
//  UIImage+AppKit.swift
//  XiaoJir
//
//  Created by xionghx on 2018/10/1.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import UIKit

/// 渐变图片类型
///
/// - leftToRight: 从左到右
/// - topToBottom: 从上到下
public enum GradientImageType {
    case leftToRight
    case topToBottom
}

public extension UIImage {
    /// 根据颜色生成图片
    ///
    /// - Parameters:
    ///   - color: 生成的图片颜色值
    ///   - size: 生成的图片大小
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let react = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(react.size)
        defer {
            UIGraphicsEndImageContext()
        }

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(react)

        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }

    /// 根据颜色组生成渐变图片
    ///
    /// - Parameters:
    ///   - colors: 生成的图片颜色组
    ///   - size: 生成的图片大小
    ///   - type: 渐变类型
    ///   - cornerRadius: 圆角半径
	convenience init?(colors: [UIColor],
                             size: CGSize,
                             type: GradientImageType = .leftToRight,
                             cornerRadius: CGFloat = 0) {
        guard !colors.isEmpty && size != CGSize.zero else {
            return nil
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        switch type {
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)

        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.cornerRadius = cornerRadius

        UIGraphicsBeginImageContextWithOptions(size, gradientLayer.isOpaque, 0)
        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        gradientLayer.render(in: context)

        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }

    /// 根据颜色生成占位图片
    ///
    /// - Parameter color: 生成的占位图片颜色值
    /// - Returns: 生成的占位图片
	class func placeholder(color: UIColor = UIColor.lightGray) -> UIImage? {
        return UIImage(color: color)
    }

    /// 图片等比例拉伸
    ///
    /// - Parameter size: 需要的图片尺寸
    /// - Returns: 图片结果
	func resizedImage(size: CGSize) -> UIImage? {
        let wScale = size.width / self.size.width
        let hScale = size.height / self.size.height

        let maxScale = max(wScale, hScale)
        let newSize = CGSize(width: self.size.width * maxScale, height: self.size.height * maxScale)

        guard let cgImage = self.cgImage else {
            return nil
        }

        UIGraphicsBeginImageContext(newSize)
        defer {
            UIGraphicsEndImageContext()
        }

        var newImage = UIImage(cgImage: cgImage, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        newImage = image
        return newImage
    }

    /// 生成圆角图片
    ///
    /// - Parameters:
    ///   - size: 图片大小
    ///   - radius: 圆角值
    ///   - fillColor: 裁切区域填充颜色
    /// - Returns: 裁切后的圆角图片
	func cornerImage(size: CGSize, radius: CGFloat, fillColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }

        let rect = CGRect(origin: CGPoint.zero, size: size)
        fillColor.setFill()
        UIRectFill(rect)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.addClip()
        self.draw(in: rect)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

}
