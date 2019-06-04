//
//  APILogger.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya

public final class APILogger {

    /// 是否开启打印功能，仅 DEBUG 环境下有效
    public static var enable: Bool = true

    public static var `default`: PluginType {
        return NetworkLoggerPlugin(verbose: true, output: APILogger.reversedPrint)
    }

    private static func reversedPrint(_ separator: String, terminator: String, items: Any...) {
        #if DEBUG
        for item in items where enable {
            print(item, separator: separator, terminator: terminator)
        }
        #endif
    }

}
