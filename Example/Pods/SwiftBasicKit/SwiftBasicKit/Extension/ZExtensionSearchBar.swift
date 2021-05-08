import UIKit
import BFKit

extension UISearchBar {
    
    public var textField: UITextField? {
        if let textField = self.value(forKey: "searchField") as? UITextField  {
            return textField
        }
        for item in self.subviews {
            if item.subviews.count > 0 {
                for view in item.subviews {
                    if let vc = NSClassFromString("UISearchBarTextField"), view.isMember(of: vc) {
                        return vc as? UITextField
                    }
                }
            }
        }
        return nil
    }
    public var textColor: UIColor? {
        get {
            return textField?.textColor
        }
        set (newValue) {
            textField?.textColor = newValue
        }
    }
    public var placeholderColor: UIColor? {
        get {
            return nil
        }
        set (newValue) {
            let attribString = NSMutableAttributedString.init(string: self.placeholder ?? "")
            let length = self.placeholder?.count ?? 0
            let range = NSRange.init(location: 0, length: length)
            let color = newValue ?? UIColor.white
            attribString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
            textField?.attributedPlaceholder = attribString
        }
    }
    public var leftView: UIView? {
        get {
            return textField?.leftView
        }
        set {
            textField?.leftView = newValue
            textField?.leftViewMode = .always
        }
    }
    public var rightView: UIView? {
        get {
            return textField?.rightView
        }
        set {
            textField?.rightView = newValue
            textField?.rightViewMode = .always
        }
    }
    public var barBackgroundColor: UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            for item in self.subviews {
                if item.subviews.count > 0 {
                    for view in item.subviews {
                        if let vc = NSClassFromString("UISearchBarBackground"), view.isMember(of: vc) {
                            view.backgroundColor = newValue
                        }
                    }
                }
            }
        }
    }
}
