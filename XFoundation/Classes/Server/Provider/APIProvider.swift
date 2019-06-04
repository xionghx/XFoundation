//
//  APIProvider.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import Moya
import RxSwift

public protocol APIPageIdentifiable {
	var pageIdentifier: ObjectIdentifier { get }
}

extension UIViewController: APIPageIdentifiable {
	public var pageIdentifier: ObjectIdentifier {
		return ObjectIdentifier(self)
	}
}

extension Moya.TargetType {
	public var requestToken: String {
		return baseURL.appendingPathComponent(path).absoluteString
	}
}

extension DispatchQueue {
	fileprivate func safeAsync(_ block: @escaping () -> Void) {
		if self === DispatchQueue.main && Thread.isMainThread {
			block()
		} else {
			self.async { block() }
		}
	}
}

/// App所有网络请求的提供者
public final class APIProvider<Target>: MoyaProvider<Target> where Target: TargetType {
	
	private typealias RequestSet = [ObjectIdentifier: [(String, Cancellable)]]
	
	/// All api page requests
	///   \
	///    \_ Page requests
	///          \_ a request
	///          |_ a request
	///          ...
	///   \
	///    \_ Page requests
	///           \_ a request
	///           |_ a request
	///            ...
	///    ...
	private var _requests = RequestSet() {
		didSet {
			UIApplication.shared.isNetworkActivityIndicatorVisible = !requests.isEmpty
		}
	}
	
	private var requests: RequestSet {
		get {
			return _requests
		}
		set {
			_requests = newValue
		}
	}
	
	// MARK: - Cancellable
	
	fileprivate func addRequest(_ id: APIPageIdentifiable, requestToken: String, request: Cancellable) {
		let key = id.pageIdentifier
		let value = (requestToken, request)
		
		if var pageRequests = self.requests[key] {
			pageRequests.append(value)
			self.requests[key] = pageRequests
		} else {
			self.requests[key] = [value]
		}
	}
	
	/// 根据‘页面标识符’和‘网络请求凭证’取消页面中的特定请求
	///
	/// - Parameters:
	///   - id: 页面标识符
	///   - requestToken: 网络请求凭证
	public func cancelRequest(_ id: APIPageIdentifiable, requestToken: String) {
		let key = id.pageIdentifier
		
		guard var pageRequests = self.requests[key]  else {
			return
		}
		
		if let index = pageRequests.firstIndex(where: { $0.0 == requestToken }) {
			if !pageRequests[index].1.isCancelled {
				pageRequests.remove(at: index).1.cancel()
			}
			
			if pageRequests.isEmpty {
				self.requests[key] = nil
			} else {
				self.requests[key] = pageRequests
			}
		}
	}
	
	/// 根据‘页面标识符’取消页面中的所有网络请求
	///
	/// - Parameter id: 页面标识符
	public func cancelRequests(_ id: APIPageIdentifiable) {
		let key = id.pageIdentifier
		
		if let pageRequests = self.requests[key] {
			for (_, request) in pageRequests where !request.isCancelled {
				request.cancel()
			}
			self.requests[key] = nil
		}
	}
	
	/// 取消所有页面网络请求
	public func cancelAllRequests() {
		for (key, pageRequests) in self.requests {
			for (_, request) in pageRequests where !request.isCancelled {
				request.cancel()
			}
			self.requests[key] = nil
		}
	}
	
}

extension Moya.MoyaProvider: XFoundationCompatible { }

extension XFoundation where Base: Moya.MoyaProviderType {
	
	/// 表单提交
	///
	/// - Parameters:
	///   - target: 构建请求所需信息
	///   - parenter: 指示器的容器
	///   - pageIdentifier: 页面标识符
	///   - callbackQueue: 结果回调的线程
	/// - Returns: 含有响应信息的信号
	public func request(
		_ target: Base.Target,
		parenter: UIView? = nil,
		pageIdentifier: APIPageIdentifiable? = nil,
		callbackQueue: DispatchQueue? = nil) -> Single<Response> {
		
		DispatchQueue.main.safeAsync {
			if let container = parenter {
				Alert.showLoading(parenter: container)
			}
		}
		
		return Single.create { [weak base] single in
			let request = base?.request(target, callbackQueue: callbackQueue, progress: nil, completion: { result in
				
				DispatchQueue.main.safeAsync {
					if let container = parenter {
						Alert.hide(parenter: container)
					}
				}
				
				switch result {
				case let .success(response):
					single(.success(response))
				case let .failure(error):
					single(.error(APIError.underlying(error: error)))
				}
			})
			
			if
				let id = pageIdentifier,
				let provider = base as? APIProvider<Base.Target>,
				let request = request
			{
				provider.addRequest(id, requestToken: target.requestToken, request: request)
			}
			
			return Disposables.create {
				if let id = pageIdentifier, let provider = base as? APIProvider<Base.Target> {
					provider.cancelRequest(id, requestToken: target.requestToken)
				} else {
					request?.cancel()
				}
			}
		}
	}
	
	/// 图片上传
	///
	/// - Parameters:
	///   - target: 构建请求所需信息
	///   - parenter: 指示器的容器
	///   - pageIdentifier: 页面标识符
	///   - callbackQueue: 结果回调的线程
	/// - Returns: 含有响应信息进度的信号
	public func upload(_ target: Base.Target,
					   parenter: UIView? = nil,
					   pageIdentifier: APIPageIdentifiable? = nil,
					   callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
		
		DispatchQueue.main.safeAsync {
			if let container = parenter {
				Alert.showLoading(parenter: container)
			}
		}
		
		let progressBlock: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
			return { progress in
				(callbackQueue ?? DispatchQueue.main).async {
					observer.onNext(progress)
				}
			}
		}
		
		let response: Observable<ProgressResponse> = Observable.create { [weak base] observer in
			let request = base?.request(target, callbackQueue: callbackQueue, progress: progressBlock(observer)) { result in
				
				DispatchQueue.main.safeAsync {
					if let container = parenter {
						Alert.hide(parenter: container)
					}
				}
				
				switch result {
				case let .success(result):
					if result.data.isEmpty {
						observer.onCompleted()
					} else {
						observer.onError(APIError.invalidData)
					}
					
				case let .failure(error):
					observer.onError(APIError.underlying(error: error))
				}
			}
			
			if
				let id = pageIdentifier,
				let provider = base as? APIProvider<Base.Target>,
				let request = request
			{
				provider.addRequest(id, requestToken: target.requestToken, request: request)
			}
			
			return Disposables.create {
				if let id = pageIdentifier, let provider = base as? APIProvider<Base.Target> {
					provider.cancelRequest(id, requestToken: target.requestToken)
				} else {
					request?.cancel()
				}
			}
		}
		
		return response.scan(ProgressResponse()) { last, progress in
			let progressObject = progress.progressObject ?? last.progressObject
			let response = progress.response ?? last.response
			return ProgressResponse(progress: progressObject, response: response)
		}
	}
	
	
	/// 文件下载
	///
	/// - Parameters:
	///   - target: 构建请求所需信息
	///   - parenter: 指示器的容器
	///   - pageIdentifier: 页面标识符
	///   - callbackQueue: 结果回调线程
	/// - Returns: 含有响应信息进度的信号
	public func download(_ target: Base.Target,
						 parenter: UIView? = nil,
						 pageIdentifier: APIPageIdentifiable? = nil,
						 callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
		
		DispatchQueue.main.safeAsync {
			if let container = parenter {
				Alert.showLoading(parenter: container)
			}
		}
		
		let progressBlock: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
			return { progress in
				(callbackQueue ?? DispatchQueue.main).async {
					observer.onNext(progress)
				}
			}
		}
		
		let response: Observable<ProgressResponse> = Observable.create { [weak base] observer in
			let request = base?.request(target, callbackQueue: callbackQueue, progress: progressBlock(observer)) { result in

				DispatchQueue.main.safeAsync {
					if let container = parenter {
						Alert.hide(parenter: container)
					}
				}

				switch result {
				case let .success(result):
					
					if result.statusCode == 200 {
						
						observer.onCompleted()

					} else {
						
						observer.onError(APIError.exceptionRequest(code: Int64(result.statusCode), message: result.description))
					}
					
					
//					if result.data.isEmpty {
//						observer.onCompleted()
//					} else {
//						observer.onError(APIError.invalidData)
//					}

				case let .failure(error):
					observer.onError(APIError.underlying(error: error))
				}
			}
//			let request = base?.request(target, callbackQueue: callbackQueue, progress: progress, completion: { (result) in
//
//			})
//

			
			if
				let id = pageIdentifier,
				let provider = base as? APIProvider<Base.Target>,
				let request = request
			{
				provider.addRequest(id, requestToken: target.requestToken, request: request)
			}
			
			return Disposables.create {
				if let id = pageIdentifier, let provider = base as? APIProvider<Base.Target> {
					provider.cancelRequest(id, requestToken: target.requestToken)
				} else {
					request?.cancel()
				}
			}
		}
		
		return response.scan(ProgressResponse()) { last, progress in
			let progressObject = progress.progressObject ?? last.progressObject
			let response = progress.response ?? last.response
			return ProgressResponse(progress: progressObject, response: response)
		}
	}
	
	
}
