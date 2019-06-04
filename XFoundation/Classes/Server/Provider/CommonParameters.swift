//
//  CommonParameters.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Foundation

/// 网络请求公共参数选项
public struct CommonParameters: OptionSet {

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    /// 没有公共参数
    public static let none = CommonParameters(rawValue: 0)
    /// 登录凭证
    public static let token = CommonParameters(rawValue: 1)
    /// 所有公共选项
    public static let allOptions: CommonParameters = [.token]

}
