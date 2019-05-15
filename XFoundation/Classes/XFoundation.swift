import Foundation

public struct XFoundationWrapper<Base> {
	public let base: Base
	
	public init(_ base: Base) {
		self.base = base
	}
}

public protocol XFoundationCompatible: AnyObject { }
//	associatedtype CompatibleType
//
//	static var app: AppKit<CompatibleType>.Type { get }
//	var app: AppKit<CompatibleType> { get }


extension XFoundationCompatible {
	
	public static var xf: XFoundationWrapper<Self>.Type {
		get {
			return XFoundationWrapper<Self>.self
		}
		set { }
	}
	
	public var xf: XFoundationWrapper<Self> {
		get {
			return XFoundationWrapper(self)
		}
		set { }
	}
	
}

extension NSObject: XFoundationCompatible { }
