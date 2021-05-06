
import UIKit
import BFKit

/// 进度条
public class ZProgressView: UIView {

    /// 拖动进度改变 - 未实现
    public var onDragProgressChange: ((_ time: Double) -> Void)?
    /// 是否允许拖动 - 未实现
    public var isDragProgress: Bool = false
    /// 完成播放进度
    public var progressValue: Float = 0.0 {
        didSet {
            let scale = CGFloat(self.progressValue > 1 ? 1 : self.progressValue)
            self.viewFinishPlayProgress.width = self.width * scale
        }
    }
    /// 缓冲进度
    public var trackValue: Float = 0.0 {
        didSet {
            let scale = CGFloat(self.trackValue > 1 ? 1 : self.trackValue)
            self.viewBufferProgress.width = self.width * scale
        }
    }
    /// 已经播放的进度颜色
    public var finishBackgroundColor: UIColor = "#FFFFFF".color {
        didSet {
            self.viewFinishPlayProgress.backgroundColor = self.finishBackgroundColor
        }
    }
    /// 缓冲进度颜色
    public var bufferBackgroundColor: UIColor = "#FFFFFF".color.withAlphaComponent(0.4) {
        didSet {
            self.viewBufferProgress.backgroundColor = self.bufferBackgroundColor
        }
    }
    /// 缓冲进度颜色
    private lazy var viewBufferProgress: UIView = {
        let temp = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: self.height))
        temp.backgroundColor = self.bufferBackgroundColor
        return temp
    }()
    /// 已经播放的进度颜色
    private lazy var viewFinishPlayProgress: UIView = {
        let temp = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: self.height))
        temp.backgroundColor = self.finishBackgroundColor
        return temp
    }()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = "#FFFFFF".color.withAlphaComponent(0.2)
        self.addSubview(viewBufferProgress)
        self.addSubview(viewFinishPlayProgress)
        self.bringSubviewToFront(viewFinishPlayProgress)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
