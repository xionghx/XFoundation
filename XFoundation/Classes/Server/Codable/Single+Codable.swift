//
//  Single+Codable.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper
extension PrimitiveSequence where TraitType == RxSwift.SingleTrait, ElementType == Moya.Response {

    /// `请求结果`数据解析器
    ///
    /// - Parameters:
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 是否请求成功
    public func mapBool(keyPath: String? = nil, decrypt: Bool = false) -> Single<Bool> {
        return flatMap { response -> Single<Bool> in
            do {
                return Single.just(try response.mapBool(keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Single.error(error)
            }
        }
    }

    /// `自定义类型`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的自定义对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的自定义类型
    public func mapCustom<T: CustomMappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Single<T> {
        return flatMap { response -> Single<T> in
            do {
                return Single.just(try response.mapCustom(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Single.error(error)
            }
        }
    }

    /// `对象`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的对象
    public func mapObject<T: Mappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Single<T> {
        return flatMap { response -> Single<T> in
            do {
                return Single.just(try response.mapObject(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Single.error(error)
            }
        }
    }

    /// `列表`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的对象列表
    public func mapArray<T: Mappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Single<[T]> {
        return flatMap { response -> Single<[T]> in
            do {
                return Single.just(try response.mapArray(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Single.error(error)
            }
        }
    }

    /// `分页列表`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的对象分页列表
    public func mapPage<T: Mappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Single<List<T>> {
        return flatMap { response -> Single<List<T>> in
            do {
                return Single.just(try response.mapPage(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Single.error(error)
            }
        }
    }

}
