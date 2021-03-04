
import UIKit

extension CGRect {
    public var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            var newFrame = self
            newFrame.origin.x = newValue
            self = newFrame
        }
    }
    public var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            var newFrame = self
            newFrame.origin.y = newValue
            self = newFrame
        }
    }
    public var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            var newFrame = self
            newFrame.size.width = newValue
            self = newFrame
        }
    }
    public var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            var newFrame = self
            newFrame.size.height = newValue
            self = newFrame
        }
    }
    public init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
    public static func main() -> CGRect {
        return CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
    }
    public static func mainRemoveTop() -> CGRect {
        return CGRect.init(x: 0, y: kTopNavHeight, width: kScreenWidth, height: kScreenMainHeight)
    }
}
extension UIEdgeInsets {
    public init(_ value: CGFloat) {
        let val = (value).scale
        self.init(top: val, left: val, bottom: val, right: val)
    }
}
extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var newFrame = self.frame
            newFrame.origin.x = newValue
            self.frame = newFrame
        }
    }
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var newFrame = self.frame
            newFrame.origin.y = newValue
            self.frame = newFrame
        }
    }
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
    }
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
    }
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    public func screenShots() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension UIAlertAction {
    
    private struct AssociatedKey {
        static var viewTag = "viewTag"
    }
    public var tag: Int {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.viewTag) as? Int else {
                return 0
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewTag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
