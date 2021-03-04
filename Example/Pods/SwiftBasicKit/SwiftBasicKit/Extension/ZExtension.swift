
import UIKit
import BFKit

extension CGFloat {
    /// 屏幕分辨率和设计图转换
    public var scale: CGFloat {
        return self * kScreenScale
    }
    public var str: String {
        return String(format: "%.f", self)
    }
    public var strDouble: String {
        return String(format: "%.2f", self)
    }
}
extension Int {
    /// 屏幕分辨率和设计图转换
    public var scale: CGFloat {
        return CGFloat(self) * kScreenScale
    }
    public var str: String {
        return String(self)
    }
}
extension Double {
    /// 屏幕分辨率和设计图转换
    public var scale: CGFloat {
        return CGFloat(self) * kScreenScale
    }
    public var str: String {
        return String(format: "%.f", self)
    }
    public var strDouble: String {
        return String(format: "%.2f", self)
    }
}
extension Int32 {
    public var str: String {
        return String(self)
    }
}
extension Int64 {
    public var str: String {
        return String(self)
    }
}
extension Float {
    public var str: String {
        return String(format: "%.f", self)
    }
    public var strDouble: String {
        return String(format: "%.2f", self)
    }
}
extension UInt32 {
    public static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        var m: UInt32
        let u = upper - lower
        var r = arc4random()
        if u > UInt32(UInt32.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        while r < m {
            r = arc4random()
        }
        return (r % u) + lower
    }
    public var str: String {
        return String(self)
    }
}
extension Error {
    
    public var code: Int {
        return (self as NSError).code
    }
    public var domain: String {
        return (self as NSError).domain
    }
}

