//
//  ContentStateView.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/27.
//  Copyright © 2018 xionghx. All rights reserved.
//

import UIKit
import SnapKit

/// 临时写法，后期需要单独封装
public final class ContentStateView: UIView {

    public var imageTopMargin: CGFloat = 50 {
        didSet {
            imageTop?.update(offset: imageTopMargin)
        }
    }
    
    private let contentView = UIView()

    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")

        return imageView
    }()

    public let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(hex: "#A8B0BF")
        label.text = "暂无数据"

        return label
    }()

    private var imageTop: Constraint?

    private struct Config {
        static let labelTop: CGFloat = 14
    }

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(label)

        contentView.snp.makeConstraints { (make) in
            imageTop = make.top.equalToSuperview().offset(imageTopMargin).constraint
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(Config.labelTop)
            make.left.right.equalTo(imageView)
            make.bottom.equalToSuperview()
        }
    }

}

extension ContentStateView {

    public static func show(at parenter: UIView,
                            title: String? = nil,
                            imageTopMargin: CGFloat? = nil) {
        ContentStateView.hide(at: parenter)

        let stateView = ContentStateView()
        parenter.addSubview(stateView)

        if let title = title {
            stateView.label.text = title
        }

        if let imageTopMargin = imageTopMargin {
            stateView.imageTopMargin = imageTopMargin
        }

        stateView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    public static func hide(at parenter: UIView) {
        for stateView in parenter.subviews where stateView as? ContentStateView != nil {
            stateView.removeFromSuperview()
        }
    }

}
