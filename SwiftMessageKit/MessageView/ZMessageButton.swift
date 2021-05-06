
import UIKit
//import InputBarAccessoryView

public class ZMessageButton: UIButton, InputItem {
    
    private var timer: Timer?
    public var inputBarAccessoryView: InputBarAccessoryView?
    public var parentStackViewPosition: InputStackView.Position?
    
    public func textViewDidChangeAction(with textView: InputTextView) {
        
    }
    public func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
        
    }
    public func keyboardEditingEndsAction() {
        
    }
    public func keyboardEditingBeginsAction() {
        
    }
    
    public required convenience init() {
        self.init(frame: CGRect.zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.adjustsImageWhenHighlighted = false
        self.isUserInteractionEnabled = true
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        self.stopButtonJitter()
    }
}
extension ZMessageButton {
    
    /// 执行按钮抖动行为
    public func startButtonJitter() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animationBegin), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    @objc
    private func animationBegin() {
        self.layer.add(self.shakeAnimate(repeatCount: 5, duration: 0.2, values: [-Double.pi/12, Double.pi/12,-Double.pi/12]), forKey: "transform.rotation")
    }
    /// 停止抖动行为
    public func stopButtonJitter() {
        self.timer?.invalidate()
        self.timer = nil
        if let keys = self.layer.animationKeys(), keys.contains("transform.rotation") {
            self.layer.removeAnimation(forKey: "transform.rotation")
        }
    }
    /// 设置按钮摇动动画
    /// - Parameters:
    ///   - repeatCount: 重复次数
    ///   - duration: 持续时间
    ///   - values:  //抖动幅度数组：不需要太大：从-15度 到 15度、再回到原位置、为一个抖动周期
    /// - Returns: 返回动画 CAKeyframeAnimation
    private func shakeAnimate(repeatCount: Float, duration: CFTimeInterval,values: [Any]) -> CAKeyframeAnimation {
        let keyAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        //keyAnimation.delegate = self
        // 开始时间
        keyAnimation.beginTime = CACurrentMediaTime()
        // 持续时间
        keyAnimation.duration = duration
        // 摇动的动画值
        keyAnimation.values = values
        // 重复次数 MAXFLOAT 无限次
        keyAnimation.repeatCount = repeatCount
        // 完成后是否移除
        keyAnimation.isRemovedOnCompletion = true
        
        return keyAnimation
    }
}
