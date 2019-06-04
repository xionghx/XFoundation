//
//  MaskView.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/30.
//  Copyright © 2018 xionghx. All rights reserved.
//

import UIKit

public class MaskView: UIView {
	
	// MARK: - Property
	
	/// 蒙版颜色:默认黑色,0.5透明度
	public var maskColor: UIColor = UIColor(white: 0, alpha: 0.5) {
		didSet {
			refreshMask()
		}
	}
	
	/// 透明区数组
	private var transparentPaths =  [UIBezierPath]()
	
	private lazy var fillLayer: CAShapeLayer = {
		
		let layer = CAShapeLayer()
		layer.frame = bounds
		self.layer.addSublayer(layer)
		return layer
	}()
	private lazy var overlayPath: UIBezierPath = {
		return generateOverlayPath()
	}()
	
	// MARK: - Intial
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupSubView()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupSubView() {
		backgroundColor = UIColor.clear
		refreshMask()
		fillLayer.path = overlayPath.cgPath
		fillLayer.fillRule = .evenOdd
		fillLayer.fillColor = maskColor.cgColor
		
//		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMaskView))
//		addGestureRecognizer(tapGesture)
		
	}
	
	public override func layoutSubviews() {
		refreshMask()
	}
	
	/// 添加矩形透明区
	///
	/// - Parameters:
	///   - rect: 位置
	///   - radius: 弧度
	public func addTransparentIn(rect: CGRect, with radius: CGFloat) {
		let transparentPath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
		add(transparentPath: transparentPath)
	}
	/// 添加圆形透明区
	///
	/// - Parameter rect: 位置
	public func addTransparentOval(rect: CGRect) {
		
		let transparentPath = UIBezierPath(rect: rect)
		add(transparentPath: transparentPath)
	}
	
	/// 添加图片
	///
	/// - Parameters:
	///   - image: 图片
	///   - frame: 位置
	public func add(image: UIImage, with frame: CGRect) {
		let imageView = UIImageView(frame: frame)
		imageView.backgroundColor = UIColor.clear
		imageView.image = image
		addSubview(imageView)
	}
	
	/// 添加文字
	///
	/// - Parameters:
	///   - label: 文字
	///   - frame: 位置
	public func add(label: UILabel, with frame: CGRect) {
		label.backgroundColor = UIColor.clear
		label.frame = frame
		addSubview(label)
	}
	
	/// 显示蒙版(过渡动画)
	///
	/// - Parameter view: 容器
	public func showMaskViewIn(view: UIView) {
		alpha = 0
		view.addSubview(self)
		UIView.animate(withDuration: 0.3) {
			self.alpha = 1
		}
	}
	
	/// 销毁蒙版
	@objc public func dismissMaskView() {
		UIView.animate(withDuration: 0.3, animations: { [weak self] in
			self?.alpha = 0
			}, completion: { [weak self] _ in
				self?.removeFromSuperview()
		})
	}
	
	private func refreshMask() {
		let overlayPath: UIBezierPath  = self.overlayPath
		for transparentPath: UIBezierPath in self.transparentPaths {
			overlayPath.append(transparentPath)
		}
		
	}
	
	private func add(transparentPath: UIBezierPath) {
		
		overlayPath.append(transparentPath)
		transparentPaths.append(transparentPath)
		fillLayer.path = overlayPath.cgPath
	}
	
	private func generateOverlayPath() -> UIBezierPath {
		let overlayPath = UIBezierPath(rect: bounds)
		overlayPath.usesEvenOddFillRule = true
		return overlayPath
	}
	
}
