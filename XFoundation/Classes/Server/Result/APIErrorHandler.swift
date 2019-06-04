//
//  APIErrorHandler.swift
//  XiaoJir
//
//  Created by xionghx on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import UIKit
import RxSwift

public protocol APIErrorHandler {
    /// API错误处理器
    func apiErrorHandler(_ error: Error, handleLoginExpired: Bool)
}

extension APIErrorHandler {

    /// 处理 API 错误，若‘error’是 APIError，直接提示详细信息，否则不作任何处理
    ///
    /// - Parameters:
    ///   - error: 请求时的错误信息
    ///   - handleLoginExpired: 是否处理登录过期错误 默认是，并且会跳转到登录页面；如果否，会出现提示语
    public func apiErrorHandler(_ error: Error, handleLoginExpired: Bool = true) {
        guard let message = apiErrorMessage(error) else {
            return
        }



        if let e = error as? APIError, case .tokenExpired = e {
//            Configuration.logout()
			let alert = UIAlertController(title: "您的登录信息已过期，请重新登录。", message: nil, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "确认", style: .default, handler: { (_) in
//				App.currentController?.present(BaseNAV(rootViewController: LoginVC(type: .login(completionHandle: nil))), animated: true, completion: nil)
			}))
			Configue.currentController?.present(alert, animated: true, completion: nil)

            return
        }

        Alert.showTip(message)
    }

    /// 获取 API 错误信息 若‘error’是 APIError，返回详细错误信息，否则返回`nil`
    ///
    /// - Parameter error: 请求时的错误信息
    /// - Returns: 错误信息详细描述
    public func apiErrorMessage(_ error: Error) -> String? {
        guard let apiError = error as? APIError else {
            return error.localizedDescription
        }
        return apiError.errorDescription
    }

}

extension PrimitiveSequenceType where TraitType == RxSwift.SingleTrait {

    /// 异常请求处理器，若‘error’是异常请求状态，‘action’执行，反之不会执行
    ///
    /// - Parameter action: 异常请求时的操作
    /// - Returns: 原结果信号
    public func exceptionHandler(_ action: ((APIError) -> Void)? = nil) -> Single<ElementType> {
        return self.do(onError: { error in
            guard let apiError = error as? APIError else {
                return
            }
            action?(apiError)
        })
    }

}
