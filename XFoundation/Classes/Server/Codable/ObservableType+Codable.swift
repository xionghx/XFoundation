//
//  ObservableType+Codable.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya
import RxSwift
import ObjectMapper

extension ObservableType where E == Moya.Response {

    /// `请求结果`数据解析器
    ///
    /// - Parameters:
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 是否请求成功
    public func mapBool(keyPath: String? = nil, decrypt: Bool = false) -> Observable<Bool> {
        return flatMap { response -> Observable<Bool> in
            do {
                return Observable.just(try response.mapBool(keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Observable.error(error)
            }
        }
    }

    /// `自定义类型`数据解析器
    ///
    /// - Parameters:
    ///   - type: 解析的自定义对象类型
    ///   - keyPath: 自定义解析的路径
    ///   - decrypt: 是否对数据进行解密
    /// - Returns: 解析成功后的自定义对象
    public func mapCustom<T: CustomMappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            do {
                return Observable.just(try response.mapCustom(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Observable.error(error)
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
    public func mapObject<T: Mappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            do {
                return Observable.just(try response.mapObject(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Observable.error(error)
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
    public func mapArray<T: Mappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Observable<[T]> {
        return flatMap { response -> Observable<[T]> in
            do {
                return Observable.just(try response.mapArray(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Observable.error(error)
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
    public func mapPage<T: Mappable>(_ type: T.Type, keyPath: String? = nil, decrypt: Bool = false) -> Observable<List<T>> {
        return flatMap { response -> Observable<List<T>> in
            do {
                return Observable.just(try response.mapPage(type, keyPath: keyPath, decrypt: decrypt))
            } catch {
                return Observable.error(error)
            }
        }
    }

}
