//
//  Reachability.swift
//  XiaoJir
//
//  Created by xionghuanxin on 2018/9/29.
//  Copyright © 2018年 xionghx. All rights reserved.
//

import RxCocoa
import Alamofire

public final class Reachability {

    public static let shared = Reachability()

    public let status: BehaviorRelay<NetworkReachabilityManager.NetworkReachabilityStatus> = BehaviorRelay(value: .unknown)

    private let reachability = NetworkReachabilityManager()

    public func startNotifier() {
        guard let isSuccess = reachability?.startListening(), isSuccess else {
//            logger.debug("Reachability start listening failure.")
            return
        }

        reachability?.listener = { status in
            Reachability.shared.status.accept(status)
        }
    }

    public func stopNotifier() {
        reachability?.stopListening()
        Reachability.shared.status.accept(.unknown)
    }

}
