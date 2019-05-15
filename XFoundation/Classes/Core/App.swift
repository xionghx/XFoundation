//
//  App.swift
//  DeviceKit
//
//  Created by xionghx on 2019/5/15.
//

import Foundation
/// App相关信息
public final class App {
	
	private static let devie = Device()
	
	/// 屏幕像素点
	public static var scale: CGFloat {
		return UIScreen.main.scale
	}
	
	/// 1像素点
	public static var oneScale: CGFloat {
		return 1 / scale
	}
	
	/// 屏幕宽
	public static var width: CGFloat {
		return UIScreen.main.bounds.width
	}
	
	/// 屏幕高
	public static var height: CGFloat {
		return UIScreen.main.bounds.height
	}
	
	/// 以iphone6为基准的宽度比例
	public static var fitWidthScale: CGFloat {
		return width/375
	}
	
	/// 以iphone6为基准的高度比例
	public static var fitHeightScale: CGFloat {
		return height/667
	}
	
	/// 屏幕大小
	public static var size: CGSize {
		return CGSize(width: App.width, height: App.height)
	}
	
	// MARK: AppInfo
	
	/// App版本号
	public static var versionNo: String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
	}
	
	/// App窗口
	public static var widow: UIWindow {
		guard let delegate = UIApplication.shared.delegate, let window = delegate.window, let view = window else {
			fatalError("App must set a key window.")
		}
		return view
	}
	
	/// 当前最顶层控制器
	public class var currentController: UIViewController? {
		return UIViewController.topMost(of: App.widow.rootViewController)
	}
	
	/// 状态栏高度
	public static var statusBarHeight: CGFloat {
		return iPhoneX ? 44 : 20
	}
	
	/// 标签栏高度
	public static var tabBarHeight: CGFloat {
		return iPhoneX ? (49 + 34) : 49
	}
	
	/// 导航栏高度
	public static var navigationBarHeight: CGFloat {
		return statusBarHeight + 44
	}
	
	/// 当前设备是否为模拟器
	public static var isSimulator: Bool {
		return devie.isSimulator
	}
	
	/// 当前设备是否是iPhoneX
	public static var iPhoneX: Bool {
		return devie.isOneOf([.iPhoneX, .iPhoneXr, .iPhoneXs, .iPhoneXsMax, .simulator(.iPhoneX), .simulator(.iPhoneXr), .simulator(.iPhoneXs), .simulator(.iPhoneXsMax)])
	}
	
	// MARK: Function
//	
//	/// 打开系统设置
//	public static func openSystemSettings() {
//		if let url = URL(string: UIApplication.openSettingsURLString) {
//			App.open(url: url)
//		}
//	}
//
//	/// 拨打电话
//	public static func call(phone: String) {
//		if let url = URL(string: "tel://" + phone) {
//			App.open(url: url)
//		}
//	}
//
//	/// 尝试打开链接
//	public static func open(url: URL, completionHandler: ((Bool) -> Void)? = nil) {
//		guard UIApplication.shared.canOpenURL(url) else {
//			completionHandler?(false)
//			return
//		}
//		UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
//	}
//
//	// MARK: - Account
//
//	/// 用户信息
//	public static var user: User? {
//		guard
//			let info = UserDefaults.standard[.userInfo],
//			let user = Mapper<User>().map(JSONObject: info) else {
//				return nil
//		}
//		return user
//	}
//
//	/// 更新用户信息
//	public static func setUser(for key: User.Key, value: Any) {
//		UserDefaults.standard[.userInfo]?[key.rawValue] = value
//	}
	
}
