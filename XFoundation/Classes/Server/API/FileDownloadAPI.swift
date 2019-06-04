//
//  FileDownloadAPI.swift
//  HLZX
//
//  Created by xionghx on 2019/5/16.
//  Copyright © 2019 xionghuanxin. All rights reserved.
//

import Moya
import CryptoSwift

let fileDownloadAPI = APIProvider(endpointClosure: { (target: FileDownloadTarget) -> Endpoint in
	return MoyaProvider.defaultEndpointMapping(for: target)
}, requestClosure: { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
	if var request = try? endpoint.urlRequest() {
		request.timeoutInterval = appEnv.timeout
		closure(.success(request))
	}
}, plugins: [APILogger.default])



enum FileDownloadTarget {
	case upgradeFile(fileName: String)
	case checkVersion
}

extension FileDownloadTarget: RequestTargetType {
	
	var baseURL: URL {
		return appEnv.baseUrl
	}
	
	var path: String {
		switch self {
		case .upgradeFile:
			return "/versions/files"
		case .checkVersion:
			return "/versions"
		}
		
	}
	var method: Moya.Method {
		switch self {
		case .upgradeFile:
			return .get
		case .checkVersion:
			return .get

		}
	}
	
	var encrypt: Bool {
		return false
	}
	
	var options: CommonParameters {
		return .none
	}
	
	var urlParameters: [String : Any] {
		var parameters = [String: Any]()
		switch self {
		case let .upgradeFile(fileName):
		
			parameters["file_name"] = fileName

		case .checkVersion:
			break
		}
		return parameters
		
	}
	
	var bodyParameters: [String : Any] {
		let parameters = [String: Any]()
		switch self {
		case .upgradeFile:
			break
		case .checkVersion:
			break
		}
		return parameters
		
	}
	
	var task: Task {
		switch self {
		case let .upgradeFile(fileName):
//			return .downloadDestination{ _,_ in (FileDownloadTarget.defaultDownloadDir.appendingPathComponent(fileName), [.removePreviousFile])}
			return .downloadParameters(parameters: urlParameters, encoding: URLEncoding.default, destination: {  _,_ in (FileDownloadTarget.defaultDownloadDir.appendingPathComponent(fileName), [.removePreviousFile])
			})
		case .checkVersion:
			return Task.requestParameters(parameters: urlParameters, encoding: URLEncoding.default)
		}
	}
	
	
	//默认下载保存地址（用户文档目录）
	static var defaultDownloadDir: URL {
		
		let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		
		return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
	
	}
	
}
