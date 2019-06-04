//
//  RequestTargetType.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya

public protocol RequestTargetType: TargetType {
    /// 基本地址
    var baseURL: URL { get }
    /// 请求路径
    var path: String { get }
    /// 请求方式
    var method: Moya.Method { get }

    /// 测试数据 默认为空，需要时可覆盖实现
    var sampleData: Data { get }
    /// 请求数据类型 默认已实现，需要时可覆盖实现
    var task: Task { get }
    /// 验证方式 默认不作校验，需要时可覆盖实现
    var validationType: ValidationType { get }

    /// 是否对 Body 数据进行加密
    var encrypt: Bool { get }
    /// 请求头 需要时可覆盖`headers { get }`的实现，但设置的公共参数会失效
    /// 当‘bodyArrayParameters’为‘nil’时，默认为‘nil’
    /// 当‘bodyArrayParameters’有值时，默认为‘["Content-Type": "application/json"]’
    var headerParameters: [String: String]? { get }
    /// 公共参数选项，设置后，数据会放到请求头里面
    var options: CommonParameters { get }
    /// URL 参数
    var urlParameters: [String: Any] { get }
    /// Body 字典参数，与‘bodyArrayParameters’互斥
    var bodyParameters: [String: Any] { get }
    /// Body 数组参数，与‘bodyParameters’互斥，默认为‘nil’，需要时可覆盖实现
    /// 为‘nil’时使用‘bodyParameters’，反之使用‘bodyArrayParameters’
    var bodyArrayParameters: [[String: Any]]? { get }
}

public extension RequestTargetType {
    /// 默认`没有示例数据`
	var sampleData: Data { return Data() }
    /// 默认`不进行认证`
	var validationType: ValidationType { return .none }

    /// 请求头 需要时可覆盖实现，如图片上传
	var headers: [String: String]? {
        return commonHeaderParameters()
    }

	var headerParameters: [String: String]? {
        if bodyArrayParameters != nil {
            return ["Content-Type": "application/json"]
        }
        return nil
    }

	var bodyArrayParameters: [[String: Any]]? { return nil }

	var task: Task {
        if encrypt {
            if let bodyArray = bodyArrayParameters {
                let bodyData = encodingBodyArray(encrypt: true, bodyArray: bodyArray)
                return Task.requestCompositeData(bodyData: bodyData, urlParameters: urlParameters)
            }

            return Task.requestCompositeParameters(bodyParameters: bodyParameters,
                                                   bodyEncoding: DecryptEncoding.default,
                                                   urlParameters: urlParameters)
        }

        if method == .get {
            return Task.requestParameters(parameters: urlParameters, encoding: URLEncoding.default)
        }

        if let bodyArray = bodyArrayParameters {
            let bodyData = encodingBodyArray(encrypt: false, bodyArray: bodyArray)
            return Task.requestCompositeData(bodyData: bodyData, urlParameters: urlParameters)
        }

        return Task.requestCompositeParameters(bodyParameters: bodyParameters,
                                               bodyEncoding: JSONEncoding.default,
                                               urlParameters: urlParameters)
    }

}

private extension RequestTargetType {

    func commonHeaderParameters() -> [String: String]? {
        var parameters: [String: String] = [:]

        if options.isEmpty || options == .none {
            return headerParameters
        }

//        if options.contains(.token), let token = App.user?.token {
//            parameters["token"] = token
//        }

        if let headerInfo = headerParameters {
            for (key, value) in headerInfo {
                parameters[key] = value
            }
        }

        return parameters.isEmpty ? nil : parameters
    }

    func encodingBodyArray(encrypt: Bool, bodyArray: [[String: Any]]) -> Data {
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: bodyArray, options: [.prettyPrinted])
        } catch {
            jsonData = Data()
        }

        if encrypt, let string = String(data: jsonData, encoding: .utf8) {
            let encoded = CipherManager.encrypt(string)
            return encoded.data(using: .utf8) ?? jsonData
        }

        return jsonData
    }

}
