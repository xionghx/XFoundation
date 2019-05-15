import Foundation

public struct AppKit<Base> {
	public let base: Base
	
	public init(_ base: Base) {
		self.base = base
	}
}

public protocol AppKitCompatible {
	associatedtype CompatibleType
	
	static var app: AppKit<CompatibleType>.Type { get }
	var app: AppKit<CompatibleType> { get }
}

extension AppKitCompatible {
	
	public static var app: AppKit<Self>.Type {
		get {
			return AppKit<Self>.self
		}
		set { }
	}
	
	public var app: AppKit<Self> {
		get {
			return AppKit(self)
		}
		set { }
	}
	
}

extension NSObject: AppKitCompatible { }
