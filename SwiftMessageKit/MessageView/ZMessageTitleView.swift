
import UIKit
import SwiftBasicKit.Swift

public class ZMessageTitleView: UIView {

    public var defaultAvatar: UIImage? {
        didSet {
            self.imagePhoto.image = self.defaultAvatar
        }
    }
    private lazy var viewLineState: UIView = {
        let item = UIView.init(frame: CGRect.init(x: self.frame.width/2 - ZKit.kFuncScale(5), y: ZKit.kStatusHeight + ZKit.kNavigationHeight/2 - ZKit.kFuncScale(5), width: ZKit.kFuncScale(10), height: ZKit.kFuncScale(10)))
        
        item.border(color: UIColor.clear, radius: ZKit.kFuncScale(5), width: 0)
        
        return item
    }()
    private lazy var lbTitle: UILabel = {
        let item = UILabel.init(frame: CGRect.init(x: self.frame.width/2, y: ZKit.kStatusHeight + ZKit.kNavigationHeight/2 - ZKit.kFuncScale(11), width: ZKit.kFuncScale(50), height: ZKit.kFuncScale(22)))
        
        item.font = UIFont.systemFont(ofSize: 18)
        item.textColor = ZColor.shared.NavBarTitleColor
        
        return item
    }()
    private lazy var imagePhoto: UIImageView = {
        let item = UIImageView.init(frame: CGRect.init(x: self.lbTitle.frame.origin.x - ZKit.kFuncScale(40), y: ZKit.kStatusHeight + ZKit.kNavigationHeight/2 - ZKit.kFuncScale(15), width: ZKit.kFuncScale(30), height: ZKit.kFuncScale(30)))
        
        item.isUserInteractionEnabled = true
        item.border(color: .clear, radius: ZKit.kFuncScale(15), width: 0)
        
        return item
    }()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.lbTitle)
        self.addSubview(self.viewLineState)
        self.addSubview(self.imagePhoto)
        self.backgroundColor = ZColor.shared.BackgroundColor
    }
    public func setMessageTitleView(model: ZModelUserInfo) {
        self.lbTitle.text = model.nickname
        self.imagePhoto.setImageWitUrl(model.avatar, self.defaultAvatar)
        let lbTitleW = self.lbTitle.text!.getWidth(self.lbTitle.font, height: self.lbTitle.height)
        self.lbTitle.frame = CGRect.init(x: self.frame.width/2 - lbTitleW/2, y: self.lbTitle.y, width: lbTitleW, height: self.lbTitle.height)
        self.viewLineState.x = self.lbTitle.x + self.lbTitle.width + ZKit.kFuncScale(6)
        self.imagePhoto.x = self.lbTitle.x - self.imagePhoto.width - ZKit.kFuncScale(10)
        if model.role == .customerService {
            self.viewLineState.backgroundColor = UIColor.init(hex: "#02E00C")
        } else {
            if model.is_online {
                if model.is_busy {
                    self.viewLineState.backgroundColor = UIColor.init(hex: "#F60C59")
                } else {
                    self.viewLineState.backgroundColor = UIColor.init(hex: "#02E00C")
                }
            } else {
                self.viewLineState.backgroundColor = UIColor.init(hex: "#808080")
            }
        }
    }
}
