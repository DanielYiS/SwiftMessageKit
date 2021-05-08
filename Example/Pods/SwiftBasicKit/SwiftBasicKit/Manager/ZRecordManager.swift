import UIKit
import BFKit
import AVFoundation

/// 录制音频回调
public protocol ZRecordDelegate: class {
    /// 录制更新
    func recordUpdateMetra(metra: Float, audioTimeInterval: TimeInterval)
    /// 录制时长太短
    func recordTooShort()
    /// 录制错误
    func recordFailed()
    /// 取消录制
    func recordCanceled()
    /// 录音完成
    /// - parameter recordTime:        录音时长
    /// - parameter uploadWavData:     上传的 wav Data
    /// - parameter fileUrl:          wav 音频数据的本地地址
    func recordFinish(uploadWavData: Data, recordTime: TimeInterval, filePath: String)
}
/// 录制音频管理类
public class ZRecordManager: NSObject {
    /// 单例模式
    public static let shared = ZRecordManager()
    /// 最小录制时长
    public var minTime: CFTimeInterval = 10
    /// 最长录制时长
    public var maxTime: CFTimeInterval = 60 * 5
    private var recorder: AVAudioRecorder?
    private var operationQueue: OperationQueue?
    public weak var delegate: ZRecordDelegate?
    
    fileprivate let recordAudioPath = ZLocalFileApi.wavFilePath.path
    fileprivate var startTime: CFTimeInterval!
    fileprivate var endTimer: CFTimeInterval!
    fileprivate var audioTimeInterval: TimeInterval = 0
    fileprivate var isFinishRecord: Bool = true
    fileprivate var isCancelRecord: Bool = false
    /// 初始化
    public override init() {
        self.operationQueue = OperationQueue()
        super.init()
    }
    /// 检测录制需要的权限
    public static func checkPermissionAndSetupRecord(block: ((_ allowed: Bool, _ error: String?) -> Void)?) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(.playAndRecord, mode: .default, options: .duckOthers)
            session.requestRecordPermission({ allowed in
                block?(allowed, nil)
            })
        } catch let error {
            block?(false, error.localizedDescription)
        }
    }
    /// 检测是否是耳机
    public final func checkHeadphones() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    BFLog.info("headphones are plugged in")
                    break
                } else {
                    BFLog.info("headphones are unplugged")
                }
            }
        } else {
            BFLog.info("checking headphones requires a connection to a device")
        }
    }
    /// 开始录制
    public final func startRecord() {
        self.isCancelRecord = false
        self.startTime = CACurrentMediaTime()
        do {
            //基础参数
            let recordSettings:[String : AnyObject] = [
                //线性采样位数  8、16、24、32
                AVLinearPCMBitDepthKey: NSNumber(value: 16 as Int32),
                //设置录音格式  AVFormatIDKey == kAudioFormatLinearPCM
                AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM as UInt32),
                //录音通道数  1 或 2
                AVNumberOfChannelsKey: NSNumber(value: 1 as Int32),
                //设置录音采样率(Hz) 如：AVSampleRateKey == 8000/44100/96000（影响音频的质量）
                AVSampleRateKey: NSNumber(value: 8000.0 as Float),
            ]
            BFLog.debug("recordAudioPath: \(self.recordAudioPath)")
            self.recorder = try AVAudioRecorder(url: URL.init(fileURLWithPath: self.recordAudioPath), settings: recordSettings)
            self.recorder?.delegate = self
            // 用于指定音频播放器的音频电平测量开/关状态。
            self.recorder?.isMeteringEnabled = true
            self.recorder?.prepareToRecord()
        } catch let error {
            self.recorder?.delegate = nil
            self.recorder = nil
            BFLog.error("startRecord error: \(error.localizedDescription)")
            self.delegate?.recordFailed()
            return
        }
        self.perform(#selector(self.readyStartRecord), with: self, afterDelay: 0.05)
    }
    @objc private final func readyStartRecord() {
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        try? session.setCategory(AVAudioSession.Category(rawValue: AVAudioSession.Category.record.rawValue))
        
        self.recorder?.record(atTime: 0, forDuration: TimeInterval(self.maxTime))
        let operation = BlockOperation()
        operation.addExecutionBlock(updateMeters)
        self.operationQueue?.addOperation(operation)
    }
    private final func updateMeters() {
        guard let recorder = self.recorder else { return }
        repeat {
            // 刷新音频播放器全部频道的平均和峰值功率值。
            recorder.updateMeters()
            self.audioTimeInterval = recorder.currentTime
            // 获取音量的平均值 会返回当前的分贝值，取值范围是 -160 ～ 0 db， 0 是很吵， -160 是很安静
            let averagePower = recorder.averagePower(forChannel: 0)
            let lowPassResult = pow(10, (averagePower/20)) * 10
            BFLog.error("recordUpdateMetra averagePower: \(averagePower), currentTime: \(recorder.currentTime)")
            DispatchQueue.DispatchaSync(mainHandler: {
                self.delegate?.recordUpdateMetra(metra: lowPassResult, audioTimeInterval: self.audioTimeInterval)
            })
            if self.audioTimeInterval > self.maxTime {
                self.stopRecord()
            }
            Thread.sleep(forTimeInterval: 0.05)
        } while(recorder.isRecording)
    }
    public final func stopRecord() {
        self.isFinishRecord = true
        self.isCancelRecord = false
        self.endTimer = CACurrentMediaTime()
        // TODO: 录制音频小于60秒提示时间太短
        if (self.endTimer - self.startTime) < self.minTime {
            self.cancelRrcord()
            DispatchQueue.DispatchaSync(mainHandler: {
                self.delegate?.recordTooShort()
            })
        } else {
            self.audioTimeInterval = self.recorder?.currentTime ?? 0
            if self.audioTimeInterval < 1 {
                self.perform(#selector(self.readyStopRecord), with: self, afterDelay: 0.5)
            } else {
                self.readyStopRecord()
            }
        }
        self.operationQueue?.cancelAllOperations()
    }
    public final func cancelRrcord() {
        self.isCancelRecord = true
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.readyStartRecord), object: self)
        self.isFinishRecord = false
        self.recorder?.stop()
        self.recorder?.deleteRecording()
        self.recorder = nil
        self.delegate?.recordCanceled()
    }
    @objc private final func readyStopRecord() {
        self.recorder?.stop()
        self.recorder = nil
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
    }
    public final func deleteRecordFiles(path: String? = nil) {
        if path == nil {
            ZLocalFileApi.deleteFile(path: self.recordAudioPath)
        } else {
            ZLocalFileApi.deleteFile(path: path!)
        }
    }
}
extension ZRecordManager: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag && self.isFinishRecord {
            guard let wavAudioData = try? Data.init(contentsOf: URL.init(fileURLWithPath: self.recordAudioPath)) else {
                self.delegate?.recordFailed()
                self.deleteRecordFiles()
                return
            }
            BFLog.debug("audioRecorderDidFinishRecording audioTimeInterval: \(self.audioTimeInterval), recordAudioPath: \(self.recordAudioPath)")
            self.delegate?.recordFinish(uploadWavData: wavAudioData, recordTime: self.audioTimeInterval, filePath: self.recordAudioPath)
        } else {
            if !self.isCancelRecord {
                self.delegate?.recordFailed()
            }
            self.deleteRecordFiles()
            BFLog.debug("audioRecorderDidFinishRecording successfully: \(flag)")
        }
    }
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if error != nil {
            self.delegate?.recordFailed()
        }
        self.deleteRecordFiles()
        BFLog.debug("audioRecorderEncodeErrorDidOccur error: \(error?.localizedDescription ?? "")")
    }
}
