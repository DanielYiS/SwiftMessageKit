
import UIKit
import BFKit

public class ZTextField: UITextField {
    
    public var isShowBorder: Bool = false {
        didSet {
            if isShowBorder {
                self.viewLine.backgroundColor = borderNormalColor
            } else {
                self.viewLine.backgroundColor = .clear
            }
        }
    }
    public var isCopy: Bool = true
    public var isShouldBeginEditing: Bool = true
    public var maxLength: Int = 0
    public var onBeginEditEvent: (() -> Void)?
    public var placeholderColor: UIColor? = UIColor.init(hex: "#BAC8D8")
    public var borderNormalColor: UIColor? = UIColor.init(hex: "#BAC8D8") {
        didSet {
            self.viewLine.backgroundColor = borderNormalColor
        }
    }
    public var borderSelectColor: UIColor? = UIColor.init(hex: "#265267")
    
    public var fontSize: CGFloat = 15 {
        didSet {
            self.font = UIFont.systemFont(self.fontSize)
        }
    }
    public var boldSize: CGFloat = 15 {
        didSet {
            self.font = UIFont.boldSystemFont(self.fontSize)
        }
    }
    public var isBoldFont: Bool = true
    private lazy var toolBarView: ZToolBarView = {
        let item = ZToolBarView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.screenWidth, height: 45))
        
        item.onDoneEvent = {
            self.resignFirstResponder()
        }
        
        return item
    }()
    private lazy var viewLine: UIView = {
        let item = UIView.init(frame: CGRect.init(0, self.height - 1, self.width, 1))
        
        return item
    }()
    public override var placeholder: String? {
        didSet {
            let attribString = NSMutableAttributedString.init(string: self.placeholder ?? "")
            
            let length = self.placeholder?.length ?? 0
            let range = NSRange.init(location: 0, length: length)
            var font = UIFont.systemFont(self.fontSize)
            if self.isBoldFont {
                font = UIFont.boldSystemFont(self.boldSize)
            }
            let color = self.placeholderColor
            attribString.addAttributes([NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color], range: range)
            self.attributedPlaceholder = attribString
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required convenience init() {
        self.init(frame: CGRect.zero, text: "")
    }
    public required convenience init(frame: CGRect, text: String) {
        self.init(frame: frame)
        
        self.text = text
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViewUI()
    }
    deinit {
        self.delegate = nil
    }
    private func setupViewUI() {
        self.font = UIFont.systemFont(self.boldSize)
        if self.isBoldFont {
            self.font = UIFont.boldSystemFont(self.fontSize)
        }
        self.returnKeyType = UIReturnKeyType.done
        self.inputAccessoryView = self.toolBarView
        self.textColor = .black
        self.tintColor = .white
        self.backgroundColor = .white
        self.keyboardAppearance = .default
        self.delegate = self
        
        self.addSubview(self.viewLine)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewLine.width = self.width
    }
    /// 设置左右间距
    public func showLeftAndRightSpace(_ width: CGFloat ,_ height: CGFloat) {
        self.leftView = UIView.init(frame: CGRect.init(0, 0, (width), (height)))
        self.rightView = UIView.init(frame: CGRect.init(0, 0, (width), (height)))
        self.leftViewMode = UITextField.ViewMode.always
        self.rightViewMode = UITextField.ViewMode.always
    }
    /// 设置是否使用功能键
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UITextField.paste(_:))
            || action == #selector(UITextField.copy(_:))
            || action == #selector(UITextField.select(_:))
            || action == #selector(UITextField.selectAll(_:)) {
            return self.isCopy
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
extension ZTextField: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        var textLength = currentText.length + string.length
        if let inputRange = currentText.toRange(from: range) {
            let newText = currentText.replacingCharacters(in: inputRange, with: string)
            textLength = newText.length
        }
        if self.maxLength > 0 && textLength > self.maxLength {
            return false
        }
        return true
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.onBeginEditEvent?()
        if self.isShowBorder {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewLine.backgroundColor = self.borderSelectColor
            })
        }
        return self.isShouldBeginEditing
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.isShowBorder {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewLine.backgroundColor = self.borderNormalColor
            })
        }
        return true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
