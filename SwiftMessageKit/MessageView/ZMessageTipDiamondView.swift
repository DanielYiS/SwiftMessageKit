
import UIKit
import SwiftBasicKit

public class ZMessageTipDiamondView: UIView {
    
    public var imageD: UIImage?
    public var colorTitle: UIColor? = UIColor.init(hex: "#252525")
    public var colorContent: UIColor? = UIColor.init(hex: "#E6F2FF").withAlphaComponent(0.5)
    
    private lazy var viewContent: UIView = {
        let item = UIView.init()
        
        item.backgroundColor = self.colorContent
        item.border(color: UIColor.clear, radius: ZKit.kFuncScale(5), width: 0)
        
        return item
    }()
    private lazy var lbTitle: UILabel = {
        let item = UILabel.init()
        
        item.text = L10n.messagesendcoinsneeds
        item.font = UIFont.systemFont(ofSize: 15)
        item.textColor = self.colorTitle
        
        return item
    }()
    private lazy var imageDiamond: UIImageView = {
        let item = UIImageView.init(image: self.imageD)
        
        return item
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.viewContent)
        self.viewContent.addSubview(self.lbTitle)
        self.viewContent.addSubview(self.imageDiamond)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setViewFrame()
    }
    private func setViewFrame() {
        self.viewContent.frame = self.bounds
        
        let lbTitleW = self.lbTitle.text!.getWidth(self.lbTitle.font, height: ZKit.kFuncScale(20))
        self.lbTitle.frame = CGRect.init(x: ZKit.kFuncScale(15), y: ZKit.kFuncScale(15), width: lbTitleW, height: ZKit.kFuncScale(20))
        self.imageDiamond.frame = CGRect.init(x: self.lbTitle.frame.origin.x + self.lbTitle.frame.width + ZKit.kFuncScale(5.5), y: ZKit.kFuncScale(18), width: ZKit.kFuncScale(17.5), height: ZKit.kFuncScale(14.5))
    }
}
