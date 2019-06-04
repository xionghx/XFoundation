//
//  FlightInfoAPI.swift
//  HLZX
//
//  Created by xionghx on 2019/4/30.
//  Copyright © 2019 xionghuanxin. All rights reserved.
//

import Moya
import CryptoSwift

let flightInfoAPI = APIProvider(endpointClosure: { (target: FlightInfoTarget) -> Endpoint in
	return MoyaProvider.defaultEndpointMapping(for: target)
}, requestClosure: { (endpoint: Endpoint, closure: MoyaProvider.RequestResultClosure) in
	if var request = try? endpoint.urlRequest() {
		request.timeoutInterval = appEnv.timeout
		closure(.success(request))
	}
}, plugins: [APILogger.default])



enum FlightInfoTarget {
	case flightInfo(flightNo: String)
}

extension FlightInfoTarget: RequestTargetType {

	var baseURL: URL {
		return appEnv.baseUrl
	}
	
	var path: String {
		switch self {
		case .flightInfo:
			return "/flight-info/flight-no"
		}
	
	}
	var method: Moya.Method {
		switch self {
		case .flightInfo:
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
		case let .flightInfo(flightNo):
			
			parameters["FlightNo"] = flightNo
		}
		return parameters
		
	}
	
	var bodyParameters: [String : Any] {
		let parameters = [String: Any]()
		switch self {
		case .flightInfo:
			break
	
		}
		return parameters

	}
	

}
