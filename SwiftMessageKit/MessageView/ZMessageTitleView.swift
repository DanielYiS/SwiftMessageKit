
import UIKit
import SwiftBasicKit

public class ZMessageTitleView: UIView {

    public var defaultAvatar: UIImage? {
        didSet {
            self.imagePhoto.image = self.defaultAvatar
        }
    }
    private lazy var viewLineState: UIView = {
        let item = UIView.init(frame: CGRect.init(x: self.frame.width/2 - (5).scale, y: kStatusHeight + kNavigationHeight/2 - (5).scale, width: (10).scale, height: (10).scale))
        
        item.border(color: UIColor.clear, radius: (5), width: 0)
        
        return item
    }()
    private lazy var lbTitle: UILabel = {
        let item = UILabel.init(frame: CGRect.init(x: self.frame.width/2, y: kStatusHeight + kNavigationHeight/2 - (11).scale, width: (50).scale, height: (22).scale))
        
        item.font = UIFont.systemFont(ofSize: 18)
        item.textColor = ZColor.shared.NavBarTitleColor
        
        return item
    }()
    private lazy var imagePhoto: UIImageView = {
        let item = UIImageView.init(frame: CGRect.init(x: self.lbTitle.frame.origin.x - (40).scale, y: kStatusHeight + kNavigationHeight/2 - (15).scale, width: (30).scale, height: (30).scale))
        
        item.isUserInteractionEnabled = true
        item.border(color: .clear, radius: (15).scale, width: 0)
        
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
        self.viewLineState.x = self.lbTitle.x + self.lbTitle.width + (6)
        self.imagePhoto.x = self.lbTitle.x - self.imagePhoto.width - (10)
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
