import UIKit
import BFKit

extension UISearchBar {
    
    public var textColor: UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                textField.textColor = newValue
            }
        }
    }
    public var placeholderColor: UIColor? {
        get {
            return nil
        }
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                let attribString = NSMutableAttributedString.init(string: self.placeholder ?? "")
                let length = self.placeholder?.count ?? 0
                let range = NSRange.init(location: 0, length: length)
                let color = newValue ?? UIColor.white
                attribString.addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
                textField.attributedPlaceholder = attribString
            }
        }
    }
    public var leftView: UIView? {
        get {
            return nil
        }
        set {
            if let textField = self.value(forKey: "searchField") as? UITextField  {
                textField.leftView = newValue
            }
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
                        if let vc = NSClassFromString("UISearchBarBackground"), view.isKind(of: vc) {
                            view.backgroundColor = newValue
                        }
                    }
                }
            }
        }
    }
    public var textFieldBackgroundColor: UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            for item in self.subviews {
                if item.subviews.count > 0 {
                    for view in item.subviews {
                        if let vc = NSClassFromString("UISearchBarTextField"), view.isKind(of: vc) {
                            (view as? UITextField)?.backgroundColor = newValue
                        }
                    }
                }
            }
        }
    }
}
