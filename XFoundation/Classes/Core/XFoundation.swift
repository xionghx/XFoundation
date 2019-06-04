import Foundation

public struct XFoundation<Base> {
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
	
	public static var xf: XFoundation<Self>.Type {
		get {
			return XFoundation<Self>.self
		}
		set { }
	}
	
	public var xf: XFoundation<Self> {
		get {
			return XFoundation(self)
		}
		set { }
	}
	
}

extension NSObject: XFoundationCompatible { }
