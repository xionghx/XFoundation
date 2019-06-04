//
//  GCD.swift
//  XiaoJir
//
//  Created by xionghx on 2018/11/27.
//  Copyright © 2018 xionghx. All rights reserved.
//

import Foundation

/// GCD定时器倒计时⏳
///   - timeInterval: 循环间隔时间
///   - repeatCount: 重复次数
///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
public func DispatchTimer(timeInterval: Double, repeatCount: Int, queue: DispatchQueue = DispatchQueue.global(), handler: @escaping (DispatchSourceTimer?, Int) -> Void) {
	if repeatCount <= 0 {
		return
	}
	let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
	var count = repeatCount
	timer.schedule(wallDeadline: .now(), repeating: timeInterval)
	timer.setEventHandler(handler: {
		count -= 1
		
		DispatchQueue.main.async {
			handler(timer, count)

		}
		if count == 0 {
			timer.cancel()
		}
	})
	timer.resume()
}

/// GCD定时器循环操作
///   - timeInterval: 循环间隔时间
///   - handler: 循环事件
public func DispatchTimer(timeInterval: Double, queue: DispatchQueue = DispatchQueue.global(), handler: @escaping (DispatchSourceTimer?) -> Void) -> DispatchSourceTimer {
	let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
	timer.schedule(deadline: .now(), repeating: timeInterval)
	timer.setEventHandler {
		DispatchQueue.main.async {
			handler(timer)
		}
	}
	timer.resume()
	return timer
}

/// GCD延时操作
///   - after: 延迟的时间
///   - handler: 事件
public func DispatchAfter(after: Double, handler: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + after) {
		handler()
	}
}
