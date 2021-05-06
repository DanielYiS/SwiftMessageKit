
import UIKit

/// 时间倒计时视图 - 秒为单位
public class ZTimeCountdownView: UIView {
    
    public var z_maxtime: TimeInterval = 20 {
        didSet {
            self.viewProgressBar.maxprogress = z_maxtime
            self.lbTime.text = String(format: "%.f", z_maxtime)
        }
    }
    private lazy var viewProgressBar: ZCircularProgressBar = {
        let item = ZCircularProgressBar.init(frame: CGRect.init(0, 0, 54.scale, 54.scale))
        return item
    }()
    private lazy var viewTime: UIView = {
        let item = UIView.init(frame: CGRect.init(7.scale, 7.scale, 40.scale, 40.scale))
        item.backgroundColor = "#6F37E7".color
        item.border(color: .clear, radius: 20.scale, width: 0)
        return item
    }()
    private lazy var lbTime: UILabel = {
        let item = UILabel.init(frame: self.viewTime.bounds)
        item.text = String(format: "%.f", z_maxtime)
        item.boldSize = 18
        item.textColor = "#FFFFFF".color
        item.textAlignment = .center
        item.backgroundColor = .clear
        return item
    }()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.viewProgressBar)
        self.addSubview(self.viewTime)
        self.viewTime.addSubview(self.lbTime)
        self.bringSubviewToFront(self.viewTime)
    }
    public final func func_settime(time: Double) {
        self.lbTime.text = String(format: "%.f", time)
        self.lbTime.layer.removeAllAnimations()
        
        let animation = CAKeyframeAnimation.init()
        animation.keyPath = "transform.scale";
        animation.values = [1.0, 1.4]
        animation.repeatCount = 1//MAXFLOAT
        animation.duration = 1
        animation.isRemovedOnCompletion = true
        animation.autoreverses = false
        self.lbTime.layer.add(animation, forKey: "Animation_transform_scale")
        
        self.viewProgressBar.startProgress()
    }
}
