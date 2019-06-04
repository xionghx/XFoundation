//
//  DecryptEncoding.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Alamofire

public struct DecryptEncoding: ParameterEncoding {

    public static var `default`: DecryptEncoding { return DecryptEncoding() }

    public let options: JSONSerialization.WritingOptions

    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            if let string = String(data: data, encoding: .utf8) {
                urlRequest.httpBody = CipherManager.encrypt(string).data(using: .utf8)
            } else {
                urlRequest.httpBody = data
            }
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        return urlRequest
    }

}
