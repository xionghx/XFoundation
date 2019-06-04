//
//  CipherManager.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import CryptoSwift

public final class CipherManager {

    public static func encrypt(_ value: String) -> String {
        return value
    }

    public static func decrypt(_ value: String) -> String {
        return value
    }

    public static func hmac(_ key: String, value: String) -> String? {
        do {
            return try HMAC(key: key, variant: .sha1).authenticate(value.bytes).toBase64()
        } catch {
            return nil
        }
    }

}
