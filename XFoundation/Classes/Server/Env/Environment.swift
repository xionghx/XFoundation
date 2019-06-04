//
//  Environment.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Foundation

public var appEnv: EnvironmentType = .local

/// App 环境状态
///
/// - local: 本地环境
/// - test: 测试环境
/// - develop: 开发环境
/// - product: 生产环境
public enum EnvironmentType: String {
    case local
    case test
    case develop
    case product

    /// 全部环境类型
    public static var allTypes: [EnvironmentType] {
        return [.local, .test, .develop, .product]
    }
}

public extension EnvironmentType {

    /// 请求超时时间
	var timeout: TimeInterval {
        return 30
    }

    /// 请求基本地址
	var baseUrl: URL {
        switch appEnv {
        case .local:
			return URL(string: "http://192.168.100.161:8000/v1")!
        case .develop:
			return URL(string: "http://47.104.84.192:9092/v1")!
        case .test:
			return URL(string: "http://mnp.wsb100.net:8000")!
        case .product:
            return URL(string: "http://mnp.chengdu.cn")!
        }
    }
	


}
