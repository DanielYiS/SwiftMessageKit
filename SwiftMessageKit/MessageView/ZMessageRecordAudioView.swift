import UIKit
import SwiftBasicKit.Swift

public class ZMessageRecordAudioView: UIView {
    
    private let lowerLimit: Float = -100.0
    private let arrayVolume = [
        UIImage.bundledImage(named: "RecordingSignal001"),
        UIImage.bundledImage(named: "RecordingSignal002"),
        UIImage.bundledImage(named: "RecordingSignal003"),
        UIImage.bundledImage(named: "RecordingSignal004"),
        UIImage.bundledImage(named: "RecordingSignal005"),
        UIImage.bundledImage(named: "RecordingSignal006"),
        UIImage.bundledImage(named: "RecordingSignal007"),
        UIImage.bundledImage(named: "RecordingSignal008"),
    ]
    private lazy var viewBG: UIView = {
        let item = UIView.init()
        
        item.alpha = 0.7
        item.backgroundColor = .black
        item.border(color: UIColor.clear, radius: (10), width: 0)
        
        return item
    }()
    private lazy var viewMain: UIView = {
        let item = UIView.init()
        
        item.alpha = 1
        item.backgroundColor = .clear
        item.border(color: UIColor.clear, radius: (10), width: 0)
        
        return item
    }()
    private lazy var imageCancel: UIImageView = {
        let item = UIImageView.init(image: UIImage.bundledImage(named: "RecordCancel"))
        
        return item
    }()
    private lazy var imageAudio: UIImageView = {
        let item = UIImageView.init(image: UIImage.bundledImage(named: "RecordingBkg"))
        
        return item
    }()
    private lazy var imageVolume: UIImageView = {
        let item = UIImageView.init(image: UIImage.bundledImage(named: "RecordingBkg"))
        
        return item
    }()
    private lazy var lbPrompt: UILabel = {
        let item = UILabel.init()
        
        item.font = UIFont.systemFont(ofSize: 12)
        item.text = L10n.messageSwipeCancelSend
        item.textColor = .white
        item.backgroundColor = .clear
        item.numberOfLines = 2
        item.textAlignment = .center
        
        return item
    }()
    private lazy var lbCountdown: UILabel = {
        let item = UILabel.init()
        
        item.text = "10"
        item.alpha = 0
        item.font = UIFont.systemFont(ofSize: 24)
        item.textColor = .white
        item.backgroundColor = .clear
        item.numberOfLines = 1
        item.textAlignment = .center
        
        return item
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required convenience init() {
        self.init(frame: CGRect.zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.innerInitView()
    }
    private func innerInitView() {
        self.backgroundColor = .clear
        self.alpha = 0
        self.isHidden = true
        
        self.addSubview(self.viewBG)
        self.addSubview(self.viewMain)
        self.sendSubviewToBack(self.viewBG)
        self.viewMain.addSubview(self.lbCountdown)
        self.viewMain.addSubview(self.imageAudio)
        self.viewMain.addSubview(self.imageCancel)
        self.viewMain.addSubview(self.imageVolume)
        self.viewMain.addSubview(self.lbPrompt)
    }
    
    private func setViewFrame() {
        self.viewBG.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.viewMain.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        let imageCancelW = ZKit.kFuncScale(80)
        self.imageCancel.frame = CGRect.init(x: self.viewMain.frame.width/2 - imageCancelW/2, y: ZKit.kFuncScale(15), width: imageCancelW, height: imageCancelW)
        let imageAudioW = ZKit.kFuncScale(50)
        let imageAudioH = ZKit.kFuncScale(80)
        let imageVolumeW = ZKit.kFuncScale(30)
        self.imageAudio.frame = CGRect.init(x: self.imageCancel.frame.origin.x, y: self.imageCancel.frame.origin.y - ZKit.kFuncScale(5), width: imageAudioW, height: imageAudioH)
        self.imageVolume.frame = CGRect.init(x: self.imageAudio.frame.origin.x + self.imageAudio.frame.width + ZKit.kFuncScale(10), y: self.imageAudio.frame.origin.y, width: imageVolumeW, height: imageAudioH)
        
        self.lbCountdown.frame = CGRect.init(x: 0, y: ZKit.kFuncScale(20), width: self.viewMain.frame.width, height: imageCancelW)
        self.lbPrompt.frame = CGRect.init(x: ZKit.kFuncScale(10), y: self.imageAudio.frame.origin.y + self.imageAudio.frame.height + ZKit.kFuncScale(5), width: self.viewMain.frame.width - ZKit.kFuncScale(30), height: ZKit.kFuncScale(40))
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setViewFrame()
    }
}
extension ZMessageRecordAudioView {
    
    /// 开始录音
    public final func startRecord() {
        self.alpha = 0
        self.isHidden = false
        self.imageCancel.isHidden = true
        self.imageAudio.isHidden = false
        self.imageVolume.isHidden = false
        self.lbPrompt.backgroundColor = UIColor.clear
        self.lbPrompt.text = L10n.messageSwipeCancelSend
        UIView.animate(withDuration: ZKey.number.animateTime, animations: {
            self.alpha = 1
        }, completion: { (end) in
            
        })
    }
    /// 正在录音
    public final func recording() {
        self.isHidden = false
        self.imageCancel.isHidden = true
        self.imageAudio.isHidden = false
        self.imageVolume.isHidden = false
        self.lbPrompt.backgroundColor = UIColor.clear
        self.lbPrompt.text = L10n.messageSwipeCancelSend
    }
    /// 录音过程中音量的变化
    public final func updateMetersValue(_ value: Float, _ audioTimeInterval: Int32) {
        var index = 0
        if value < 0.3 {
            index = 0
        } else if value >= 0.3 && value < 0.6 {
            index = 1
        } else if value >= 0.6 && value < 0.9 {
            index = 2
        } else if value >= 0.9 && value < 1.2 {
            index = 3
        } else if value >= 1.2 && value < 1.5 {
            index = 4
        } else if value >= 1.5 && value < 1.8 {
            index = 5
        } else if value >= 1.8 && value < 2.5 {
            index = 6
        } else {
            index = 7
        }
        self.imageVolume.image = arrayVolume[index]
        if audioTimeInterval > 50 {
            // TODO: 倒计时10秒效果
            self.lbCountdown.text = String(abs(60 - audioTimeInterval))
        }
    }
    /// 松开手指，取消发送
    public final func slideToCancelRecord() {
        self.isHidden = false
        self.imageCancel.isHidden = false
        self.imageAudio.isHidden = true
        self.imageVolume.isHidden = true
        self.lbPrompt.text = L10n.messageFingerCancelSend
    }
    /// 录音时间太短的提示
    public final func messageTooShort() {
        self.isHidden = false
        self.imageCancel.isHidden = false
        self.imageAudio.isHidden = true
        self.imageVolume.isHidden = true
        self.lbPrompt.text = L10n.messageRecordTimeShort
        //0.5秒后消失
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.endRecord()
        }
    }
    /// 录音结束
    public final func endRecord() {
        if self.isHidden && self.alpha == 0 {
            return
        }
        self.alpha = 1
        self.isHidden = false
        UIView.animate(withDuration: ZKey.number.animateTime, animations: {
            self.alpha = 0
        }, completion: { (end) in
            self.isHidden = true
        })
    }
}
