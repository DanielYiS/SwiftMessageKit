
import UIKit
import SnapKit.Swift

public class ZToolBarView: UIView {
    
    public var onDoneEvent: (() -> Void)?
    
    private lazy var btnDone: UIButton = {
        let item = UIButton.init()
        
        item.adjustsImageWhenHighlighted = false
        item.setImage(UIImage.baseImage(named: "arrow_down"), for: UIControl.State.normal)
        item.backgroundColor = .clear
        
        return item
    }()
    private lazy var viewLine1: UIView = {
        let item = UIView.init(frame: CGRect.zero)
        
        item.backgroundColor = .clear
        
        return item
    }()
    private lazy var viewLine2: UIView = {
        let item = UIView.init(frame: CGRect.zero)
        
        item.backgroundColor = .clear
        
        return item
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViewUI()
    }
    public required convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func setupViewUI() {
        self.addSubview(self.btnDone)
        self.addSubview(self.viewLine1)
        self.addSubview(self.viewLine2)
        
        self.backgroundColor = ZColor.shared.KeyboardBackgroundColor
        
        self.btnDone.addTarget(self, action: #selector(btnDoneEvent), for: UIControl.Event.touchUpInside)
    }
   public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.btnDone.snp.remakeConstraints { (make) in
            make.width.equalTo(45)
            make.top.right.equalTo(self)
            make.height.equalTo(45)
        }
        self.viewLine1.snp.remakeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        self.viewLine2.snp.remakeConstraints { (make) in
            let top = 45-0.5
            make.top.equalTo(self.snp.top).offset(top)
            make.left.right.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
    @objc private func btnDoneEvent() {
        self.onDoneEvent?()
    }
}
