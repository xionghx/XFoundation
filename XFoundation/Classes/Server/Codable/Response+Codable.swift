//
//  Response+Codable.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya
import ObjectMapper

extension Moya.Response {

    /// `请求结果`数据解析器
    ///
    /// - Parameters:
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 是否请求成功
    /// - Throws: 解析失败时的错误
    public func mapBool(keyPath: String?, decrypt: Bool) throws -> Bool {
        let keyPath = keyPath == nil ? CodableKey.Body.code : keyPath
        let code = try mapCustom(Int.self, keyPath: keyPath, decrypt: decrypt)

        return code == CodableKey.successCode
    }

    /// `自定义类型`数据解析器
    ///
    /// - Parameters:
    ///   - type: 自定义解析的类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns:  解析成功后的自定义对象
    /// - Throws: 解析失败时的错误
    public func mapCustom<T: CustomMappable>(_ type: T.Type, keyPath: String?, decrypt: Bool) throws -> T {
        let json = try validationJSON(decrypt: decrypt)

        if let keyPath = keyPath {
            guard let result = json.value(forKeyPath: keyPath) as? T else {
                throw APIError.objectMappingFailed
            }
            return result

        } else {
            guard let result = json[CodableKey.Body.data] as? T else {
                throw APIError.objectMappingFailed
            }
            return result
        }
    }

    /// `对象`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的对象
    /// - Throws: 解析失败时的错误
    public func mapObject<T: Mappable>(_ type: T.Type, keyPath: String?, decrypt: Bool) throws -> T {
        let json = try validationJSON(decrypt: decrypt)
        let object: NSDictionary

        if let keyPath = keyPath {
            guard let dict = json.value(forKeyPath: keyPath) as? NSDictionary else {
                throw APIError.objectMappingFailed
            }
            object = dict

        } else {
            guard let dict = json[CodableKey.Body.data] as? NSDictionary else {
                throw APIError.objectMappingFailed
            }
            object = dict
        }

        guard let result = Mapper<T>().map(JSONObject: object) else {
            throw APIError.objectMappingFailed
        }
        return result
    }

    /// `列表`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的对象列表
    /// - Throws: 解析失败时的错误
    public func mapArray<T: Mappable>(_ type: T.Type, keyPath: String?, decrypt: Bool) throws -> [T] {
        let json = try validationJSON(decrypt: decrypt)
        let list: NSArray

        if let keyPath = keyPath {
            guard let array = json.value(forKeyPath: keyPath) as? NSArray else {
                throw APIError.objectMappingFailed
            }
            list = array

        } else {
            guard let array = json[CodableKey.Body.data] as? NSArray else {
                throw APIError.objectMappingFailed
            }
            list = array
        }

        guard let result = Mapper<T>().mapArray(JSONObject: list) else {
            throw APIError.objectMappingFailed
        }
        return result
    }

    /// `分页列表`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的对象分页列表
    /// - Throws: 解析失败时的错误
    public func mapPage<T: Mappable>(_ type: T.Type, keyPath: String?, decrypt: Bool) throws -> List<T> {
        let json = try validationJSON(decrypt: decrypt)
        let list: NSArray
        let next: String?

        if let keyPath = keyPath {
            let single = keyPath.components(separatedBy: ".").isEmpty
            let suffixString = keyPath.components(separatedBy: ".").last ?? ""
			_ = single ? CodableKey.List.totalCount :
                keyPath.replacingOccurrences(of: suffixString, with: CodableKey.List.totalCount)
            let nextKeyPath = single ? CodableKey.List.nextURLString :
                keyPath.replacingOccurrences(of: suffixString, with: CodableKey.List.nextURLString)

            guard let array = json.value(forKeyPath: keyPath) as? NSArray else
			
            {
                throw APIError.objectMappingFailed
            }
            list = array
            next = json.value(forKeyPath: nextKeyPath) as? String

        } else {
            guard let array = json[CodableKey.List.list] as? NSArray else
            {
                throw APIError.objectMappingFailed
            }
            list = array
            next = json[CodableKey.List.nextURLString] as? String
        }

        guard let listInfo = Mapper<T>().mapArray(JSONObject: list) else {
            throw APIError.objectMappingFailed
        }

        return List(datas: listInfo, count: 0, next: next)
    }

}

private extension Moya.Response {

    func validationJSON(decrypt: Bool) throws -> NSDictionary {
        guard
            let json = try mapJSON(decrypt: decrypt) as? NSDictionary,
            let code = json[CodableKey.Body.code] as? Int64 else
        {
            throw APIError.invalidData
        }

        if code == CodableKey.tokenExpiredCode {
            throw APIError.tokenExpired
        }

        guard code == CodableKey.successCode || code == CodableKey.bindingOpenId else {
            let message = json[CodableKey.Body.message] as? String
            throw APIError.exceptionRequest(code: code, message: message)
        }
        return json
    }

    func mapJSON(decrypt: Bool) throws -> Any {
        var rawData = data
        if decrypt, let string = String(data: data, encoding: .utf8) {
            guard let decryptedData = CipherManager.decrypt(string).data(using: .utf8) else {
                return NSNull()
            }
            rawData = decryptedData
        }
        do {
            return try JSONSerialization.jsonObject(with: rawData, options: .allowFragments)
        } catch {
            if data.count < 1 {
                return NSNull()
            }
            throw APIError.jsonSerializationFailed(error: error)
        }
    }

}
