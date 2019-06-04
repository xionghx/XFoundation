//
//  APIResult.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import ObjectMapper

/// API 请求结果
///
/// - success: 数据请求且解析成功
/// - failure: 数据请求或解析失败
public enum APIResult<Value> {
    case success(Value)
    case failure(Error)
}

public struct List<T: Mappable> {
    /// 列表数据
    public let datas: [T]
    /// 列表总数
    public let totalCount: Int
    /// 是否有下一页数据
    public let hasNext: Bool

    internal init(datas: [T], count: Int, next: String?) {
        self.datas = datas
        self.totalCount = count
        self.hasNext = next != nil && next?.isEmpty == false
    }
}
