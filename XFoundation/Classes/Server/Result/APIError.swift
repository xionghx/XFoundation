//
//  APIError.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya

/// API错误类型
///
/// - invalidData: 后台返回无效数据
/// - jsonSerializationFailed: JSON 解析出错
/// - objectMappingFailed: 对象映射出错
/// - loginExpired: 账号被挤
/// - tokenExpired: 令牌过期
/// - exceptionRequest: 请求异常
/// - underlying: 其他或网络异常
public enum APIError: Error, LocalizedError {
	case invalidData
	case jsonSerializationFailed(error: Error)
	case objectMappingFailed
	case tokenExpired
	case exceptionRequest(code: Int64, message: String?)
	case underlying(error: MoyaError)
	case userNotFound
	
	public var errorDescription: String? {
		switch self {
		case .invalidData:
			return "数据出现异常"
		case .jsonSerializationFailed:
			return "JSON解析出错"
		case .objectMappingFailed:
			return "对象映射出错"
		case .tokenExpired:
			return "令牌过期"
		case let .exceptionRequest(_, message):
			return message
		case let .underlying(error):
			return error.errorDescription
		case .userNotFound:
			return "用户不存在"
		}
	}
}
