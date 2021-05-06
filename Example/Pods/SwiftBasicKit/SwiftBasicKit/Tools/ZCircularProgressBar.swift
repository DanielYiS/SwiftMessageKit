
import UIKit
import BFKit

/// 弧形进度条
public class ZCircularProgressBar: UIView {
    
    /// 进度槽
    private let trackLayer = CAShapeLayer()
    /// 进度条
    private let progressLayer = CAShapeLayer()
    /// 进度条路径（整个圆圈）
    private let path = UIBezierPath()
    /// 进度条宽度
    public var lineWidth: CGFloat = 4
    /// 进度槽颜色
    public var trackColor = UIColor.clear
    /// 进度条颜色
    public var progressColoar = "#6F37E7".color
    /// 最大进度值 在其他公共属性最后面设置前面设置的属性才有效
    public var maxprogress: Double = 20 {
        didSet {
            self.progress = self.maxprogress
            self.addProgressLayer()
        }
    }
    private var isStartAnimation: Bool = false
    /// 当前进度
    @IBInspectable public var progress: Double = 20 {
        didSet {
            if progress > maxprogress {
                progress = maxprogress
            }else if progress < 0 {
                progress = 0
            }
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /// 添加动画层
    private func addProgressLayer() {
        //获取整个进度条圆圈路径
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                    radius: bounds.size.width/2 - self.lineWidth,
                    startAngle: angleToRadian(-90), endAngle: angleToRadian(270), clockwise: true)
        
        //绘制进度槽
        trackLayer.frame = bounds
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = self.trackColor.cgColor
        trackLayer.lineWidth = self.lineWidth
        trackLayer.path = path.cgPath
        layer.addSublayer(trackLayer)
        
        //绘制进度条
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = self.progressColoar.cgColor
        progressLayer.lineWidth = self.lineWidth
        progressLayer.path = path.cgPath
        progressLayer.strokeStart = CGFloat((maxprogress - progress)/maxprogress)
        progressLayer.strokeEnd = 1
        layer.addSublayer(progressLayer)
    }
    /// 开始动画
    public final func startProgress() {
        if self.isStartAnimation {
            return
        }
        self.isStartAnimation = true
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.duration = TimeInterval(maxprogress)
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = true
        progressLayer.add(animation, forKey: "strokeStart")
    }
    /// 设置进度（可以设置是否播放动画，以及动画时间）
    public final func setProgress(_ pro: Double, animated anim: Bool = true, withDuration duration: Double = 1) {
        progress = pro
        //进度条动画
        CATransaction.begin()
        CATransaction.setDisableActions(!anim)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        CATransaction.setAnimationDuration(duration)
        progressLayer.strokeStart = CGFloat((maxprogress - progress)/maxprogress)
        CATransaction.commit()
    }
    /// 将角度转为弧度
    fileprivate func angleToRadian(_ angle: Double)->CGFloat {
        return CGFloat(angle/Double(180.0) * M_PI)
    }
    
}
