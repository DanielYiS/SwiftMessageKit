
import UIKit
import BFKit

public class ZTextView: UIView {
    
    public var onTextBeginEdit: (() -> Void)?
    public var onTextDidChange: ((_ text: String) -> Void)?
    public var placeholderColor: UIColor? = ZColor.shared.InputPromptColor {
        didSet {
            self.lbPlaceholder.textColor = placeholderColor
        }
    }
    public override var backgroundColor: UIColor? {
        didSet {
            self.textView.backgroundColor = self.backgroundColor
        }
    }
    public var textColor: UIColor? {
        didSet {
            self.textView.textColor = self.textColor
        }
    }
    public override var tintColor: UIColor? {
        didSet {
            self.textView.tintColor = self.tintColor
        }
    }
    public var placeholder: String = "" {
        willSet {
            self.lbPlaceholder.text = newValue
        }
    }
    public var text: String {
        set(newValue) {
            self.textView.text = newValue
            self.lbPlaceholder.isHidden = (newValue.length > 0)
        }
        get {
            return self.textView.text
        }
    }
    public var fontSize: CGFloat = (18) {
        willSet {
            self.textView.font = UIFont.systemFont(newValue)
        }
    }
    public var textInputAccessoryView: UIView? = nil {
        willSet {
            self.textView.inputAccessoryView = newValue
        }
    }
    public var maxLength: Int = 0
    public var isMultiline: Bool = true
    private lazy var toolBarView: ZToolBarView = {
        let item = ZToolBarView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 45))
        
        item.onDoneEvent = {
            self.textView.resignFirstResponder()
        }
        return item
    }()
    private lazy var textView: UITextView = {
        let item = UITextView.init(frame: CGRect.zero)
        
        item.text = ""
        item.scrollsToTop = false
        item.isUserInteractionEnabled = true
        item.backgroundColor = .white
        item.font = UIFont.systemFont(14)
        item.textColor = ZColor.shared.InputTextColor
        item.tintColor = ZColor.shared.InputCursorColor
        item.backgroundColor = ZColor.shared.InputBackgroundColor
        item.inputAccessoryView = self.toolBarView
        item.keyboardAppearance = .default
        
        return item
    }()
    private lazy var lbPlaceholder: UILabel = {
        let item = UILabel.init(frame: CGRect.zero)
        
        item.isUserInteractionEnabled = false
        item.font = UIFont.systemFont(ofSize: 14)
        item.textColor = self.placeholderColor
        item.numberOfLines = 0
        
        return item
    }()
    private var labelHeight: CGFloat = 22
    public var keyboardType: UIKeyboardType = UIKeyboardType.default {
        willSet {
            self.textView.keyboardType = newValue
        }
    }
    public var returnKeyType: UIReturnKeyType = UIReturnKeyType.default {
        willSet {
            self.textView.returnKeyType = newValue
        }
    }
    public override var frame: CGRect {
        willSet {
            self.textView.frame = CGRect.init(0, 0, newValue.width, newValue.height)
            self.lbPlaceholder.frame = CGRect.init(x: 5, y: 5, width: newValue.size.width - (5 * 2), height: 22)
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.textView)
        self.addSubview(self.lbPlaceholder)
        self.sendSubviewToBack(self.textView)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = ZColor.shared.InputBackgroundColor
        
        self.textView.delegate = self
    }
    deinit {
        self.textView.delegate = nil
    }
    public required convenience init() {
        self.init(frame: CGRect.zero)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textView.snp.remakeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.lbPlaceholder.snp.remakeConstraints { (make) in
            make.left.top.equalTo(self.textView).offset(5)
            make.right.equalTo(self.textView.snp.right).offset(-5)
            let width = self.width - 5 * 2
            self.labelHeight = self.placeholder.getHeight(self.lbPlaceholder.font!, width: width)
            make.height.equalTo(self.labelHeight)
        }
    }
    public func showKeyboard() {
        self.textView.becomeFirstResponder()
    }
    public func dismissKeyboard() {
        self.textView.resignFirstResponder()
    }
}
extension ZTextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !self.isMultiline {
            if text == "\n" {
                let _ = textView.resignFirstResponder()
                return false
            }
        }
        let currentText = textView.text ?? ""
        var textLength = currentText.length + text.length
        if let inputRange = currentText.toRange(from: range) {
            let newText = currentText.replacingCharacters(in: inputRange, with: text)
            textLength = newText.length
        }
        self.lbPlaceholder.isHidden = textLength > 0
        if self.maxLength > 0 && textLength > self.maxLength {
            return false
        }
        return true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.onTextBeginEdit?()
        return true
    }
    public func textViewDidChange(_ textView: UITextView) {
        self.onTextDidChange?(textView.text)
    }
}
