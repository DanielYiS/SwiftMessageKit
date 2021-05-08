
import UIKit

public class ZLabel: UILabel {
    
    /// 改变行间距
    public var linesSpacing: CGFloat = 2 {
        didSet {
            if self.text == nil || self.text == "" {
                return
            }
            let text = self.text
            let attributedString = NSMutableAttributedString.init(string: text!, attributes: [NSAttributedString.Key.kern: self.wordSpace])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = self.linesSpacing
            paragraphStyle.alignment = self.textAlignment
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: text!.length))
            self.attributedText = attributedString
            self.sizeToFit()
        }
    }
    /// 改变字间距
    public var wordSpace: CGFloat = 0 {
        didSet {
            if self.text == nil || self.text == "" {
                return
            }
            let text = self.text
            let attributedString = NSMutableAttributedString.init(string: text!, attributes: [NSAttributedString.Key.kern: self.wordSpace])
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = self.linesSpacing
            paragraphStyle.alignment = self.textAlignment
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: text!.length))
            self.attributedText = attributedString
            self.sizeToFit()
        }
    }
    public required convenience init() {
        self.init(frame: CGRect.zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.text = ""
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .black
        self.numberOfLines = 0
        self.isUserInteractionEnabled = true
        self.lineBreakMode = .byTruncatingTail
        self.backgroundColor = .clear
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
