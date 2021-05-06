
import UIKit

extension UIFont {
    
    public static func systemFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: (size))
    }
    public static func boldSystemFont(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: (size))
    }
}
extension UILabel {
    
    public var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.systemFont(newValue)
        }
    }
    public var boldSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.boldSystemFont(newValue)
        }
    }
}
