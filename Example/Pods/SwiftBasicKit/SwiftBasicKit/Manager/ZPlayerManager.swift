
import UIKit
import BFKit
import MediaPlayer
import AVFoundation

/// 播放状态枚举
public enum ZAVPlayerPlayState: Int {
    /// 准备播放
    case Preparing = 1
    /// 开始播放
    case Beigin = 2
    /// 正在播放
    case Playing = 3
    /// 播放暂停
    case Pause = 4
    /// 播放结束
    case End = 5
    /// 没有缓存的数据供播放了
    case BufferEmpty = 6
    /// 有缓存的数据可以供播放
    case BufferToKeepUp = 7
    /// 设置指定播放位置
    case SeekToZeroBeforePlay = 8
    /// 不能播放
    case NotPlay = 9
    /// 未知情况
    case NotKnow = 10
}
/// 播放各种状态代理
public protocol ZAVPlayerDelegate: class {
    /// 更新进度
    func updatePlayProgress(current: Float, total: Float)
    /// 改变播放索引
    func changeMusicToIndex(index: Int)
    /// 更新缓存进度
    func updateBufferProgress(progress: Float)
}
/// 播放状态通知Key
public let ZAVPlayerState = "ZAVPlayerState"
/// 播放地址通知Key
public let ZAVPlayerCurrentPlayUrl = "ZAVPlayerCurrentPlayUrl"
/// 播放类型通知Key
public let ZAVPlayerPlayType = "ZAVPlayerPlayType"
/// 音乐对象
public struct ZModelMusic {
    /// 音乐名称
    public var name: String = ""
    /// 音乐作者
    public var author: String = ""
    /// 音乐图片地址
    public var imageUrl: String = ""
    /// 音乐播放地址
    public var playpath: String = ""
    /// 总时长
    public var durantion: Int = 0
    /// 初始化
    public init(named: String, user: String, image: String, url: String, time: Int) {
        self.name = named
        self.author = user
        self.imageUrl = image
        self.playpath = url
        self.durantion = time
    }
}
/// 播放方式
public enum ZAVPlayerType: Int {
    /// 单曲播放 - 不循环
    case single
    /// 列表播放 - 不循环
    case list
    /// 循环播放
    case cycle
}
/// 播放管理器
public class ZAVPlayerManager: NSObject {
    /// 单例模式
    public static let shared = ZAVPlayerManager()
    /// 播放器
    private var player: AVPlayer = {
        let tmp = AVPlayer()
        // 默认最大音量
        tmp.volume = 2.0
        return tmp
    }()
    /// 播放管理器
    private var playerItem: AVPlayerItem?
    /// 当前播放链接
    private var currentUrl: String?
    /// 是否正在播放
    public var isPlay: Bool = false
    /// 应用是否进入后台
    public var isEnterBackground: Bool = false
    /// 播放前是否跳到 0
    public var seekToZeroBeforePlay: Bool = false
    /// 是否立即播放
    public var isImmediately: Bool = false
    /// 没加载玩是否暂停
    public var isEmptyBufferPause: Bool = false
    /// 是否播放结束
    public var isFinish: Bool = false
    /// 是否正在拖动slide  调整播放时间
    public var isSeekingToTime: Bool = false
    /// 后台播放申请ID
    private var bgTaskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    /// 总时长
    public var durantion: Float64 {
        if let duration = self.player.currentItem?.duration {
            return CMTimeGetSeconds(duration)
        }
        return 0.0
    }
    /// 播放进度
    private var progress: Float?
    /// 当前播放索引
    private var currentIndex: Int = 0
    /// 当前播放方式
    public var playType: ZAVPlayerType = .cycle
    /// 播放速度 改变播放速度
    public var playSpeed: Float = 1.0 {
        didSet {
            if (self.isPlay) {
                guard let playerItem = self.playerItem else {return}
                self.enableAudioTracks(enable: true, playerItem: playerItem)
                self.player.rate = playSpeed
            }
        }
    }
    /// 音频播放数组
    public var musicArray: [ZModelMusic] = [ZModelMusic]() {
        didSet {
            self.currentIndex = 0
        }
    }
    /// 播放代理
    public weak var delegate: ZAVPlayerDelegate?
    /// 时间监听器
    private var timeObserVer: Any?
    /// 当前播放对象
    public var currentModel: ZModelMusic?
    /// 初始化播放管理器
    public override init() {
        super.init()
        self.setupPlayer()
    }
    /// 播放器初始化
    private func setupPlayer() {
        self.playSpeed = 1.0
        self.player.rate = 1.0
        // APP进入后台通知
        NotificationCenter.default.addObserver(self, selector: #selector(configLockScreenPlay) , name:UIApplication.didEnterBackgroundNotification, object: nil)
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        try? session.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
    }
    /// 播放前增加配置 监测
    private func currentItemAddObserver() {
        // 监听是否靠近耳朵
        NotificationCenter.default.addObserver(self, selector: #selector(sensorStateChange), name:UIDevice.proximityStateDidChangeNotification, object: nil)
        // 播放期间被 电话 短信 微信 等打断后的处理
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterreption(sender:)), name:AVAudioSession.interruptionNotification, object:AVAudioSession.sharedInstance())
        // 监控播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(playMusicFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        // 监听状态属性 注意AVPlayer也有一个status属性 通过监控它的status也可以获得播放状态
        self.player.currentItem?.addObserver(self, forKeyPath: "status", options:[.new,.old], context: nil)
        // 监控缓冲加载情况属性
        self.player.currentItem?.addObserver(self, forKeyPath:"loadedTimeRanges", options: [.new,.old], context: nil)
        // 添加进度监听回调
        self.timeObserVer = self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { [weak self] (time) in
            guard let `self` = self else { return }
            let currentTime = CMTimeGetSeconds(time)
            self.progress = Float(currentTime)
            if self.isSeekingToTime { return }
            let total = Float(self.durantion)
            if total > 0 {
                self.delegate?.updatePlayProgress(current: Float(currentTime), total: total)
                self.setNowPlayingInfo()
            }
        }
    }
    /// 播放后   删除配置 监测
    private func currentItemRemoveObserver() {
        self.player.currentItem?.removeObserver(self, forKeyPath:"status")
        self.player.currentItem?.removeObserver(self, forKeyPath:"loadedTimeRanges")
        
        NotificationCenter.default.removeObserver(self, name:UIDevice.proximityStateDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name:AVAudioSession.interruptionNotification, object: nil)
        
        if(self.timeObserVer != nil){
            self.player.removeTimeObserver(self.timeObserVer!)
        }
    }
    /// 锁屏 或 退入后台 保持音频继续播放
    @objc private func configLockScreenPlay() {
        // 设置并激活音频会话类别
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        try? session.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
        // 允许应用接收远程控制
        UIApplication.shared.beginReceivingRemoteControlEvents()
        // 设置后台任务ID
        var  newTaskID = UIBackgroundTaskIdentifier.invalid
        newTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        if (newTaskID != UIBackgroundTaskIdentifier.invalid) && (self.bgTaskId != UIBackgroundTaskIdentifier.invalid)  {
            UIApplication.shared.endBackgroundTask(self.bgTaskId)
        }
        self.bgTaskId = newTaskID
    }
    /// 监测是否靠近耳朵  转换声音播放模式
    @objc private func sensorStateChange() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            // 靠近耳朵
            if UIDevice.current.proximityState == true {
                let session = AVAudioSession.sharedInstance()
                try? session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                return
            }
            // 远离耳朵
            let session = AVAudioSession.sharedInstance()
            try? session.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
        }
    }
    /// 处理播放音频是被来电 或者 其他 打断音频的处理
    @objc private func handleInterreption(sender: NSNotification) {
        guard let info = sender.userInfo else { return }
        guard let type: AVAudioSession.InterruptionType =  info[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType else { return }
        switch type {
        case .began: self.pause()
        default:
            guard  let options = info[AVAudioSessionInterruptionOptionKey] as? AVAudioSession.InterruptionOptions else { return }
            if(options == AVAudioSession.InterruptionOptions.shouldResume){
                self.pause()
            }
        }
    }
    /// 单个音频播放结束后的逻辑处理
    @objc private func playMusicFinished() {
        UIDevice.current.isProximityMonitoringEnabled = true
        self.seekToZeroBeforePlay = true
        self.isPlay = false
        self.updateCurrentPlayState(state: .End)
        switch self.playType {
        case .list, .cycle: self.next()
        default: break
        }
    }
}
extension ZAVPlayerManager {
    /// 回复默认播放速度
    public func resetPlaySeed() {
        self.playSpeed = 1.0
    }
    /// 设置播放速率
    public func setPlaySpeed(playSpeed: Float) {
        if self.isPlay {
            self.enableAudioTracks(enable: true, playerItem: self.playerItem!)
            self.player.rate = playSpeed;
        }
        self.playSpeed = playSpeed
    }
    /// 改变播放速率  必实现的方法
    /// - Parameters:
    ///   - enable:
    ///   - playerItem: 当前播放
    public func enableAudioTracks(enable: Bool, playerItem: AVPlayerItem) {
        for track: AVPlayerItemTrack in playerItem.tracks {
            if track.assetTrack?.mediaType == AVMediaType.audio {
                track.isEnabled = enable
            }
        }
    }
    /// 对网络音频和本地音频 地址 做统一管理
    private final func reloadAudio(playpath: String) -> URL {
        //        if let lineid = lineModel?.lineid,
        //            let path = DownloadManager.share.getRecordPath(lineid: lineid, playpath: playpath) {
        //            let url = URL(fileURLWithPath: path)
        //            return url
        //        }
        return URL(string: playpath)!
    }
    /// 用于播放单个音频   播放方法
    /// - Parameters:
    ///   - url: 播放地址
    ///   - type: 音频类型  （以便于播放多种类型的音频）
    public final func playMusic(model: ZModelMusic, type: ZAVPlayerType) {
        // 播放前初始化倍速 1.0
        self.setPlaySpeed(playSpeed: 1.0)
        // 移除上一首的通知 观察
        self.currentItemRemoveObserver()
        let playUrl = self.reloadAudio(playpath: model.playpath)
        let playerItem = AVPlayerItem(url: playUrl)
        self.playerItem = playerItem
        self.currentUrl = model.playpath
        self.isImmediately = true
        self.currentModel = model
        self.currentIndex = 0
        self.player.replaceCurrentItem(with: playerItem)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        self.currentItemAddObserver()
    }
    /// 播放多个音频的列表  播放方法
    /// - Parameters:
    ///   - index: 播放列表中的第几个音频
    ///   - isImmediately: 是否立即播放
    public final func playArray(index: Int, isImmediately: Bool) {
        self.currentItemRemoveObserver()
        guard self.musicArray.count > index else { return }
        let model = self.musicArray[index]
        let playUrl = self.reloadAudio(playpath: model.playpath)
        let playerItem = AVPlayerItem(url: playUrl)
        self.playerItem = playerItem
        self.currentUrl = model.playpath
        self.isImmediately = isImmediately
        self.currentModel = model
        self.currentIndex = index
        if !isImmediately {
            self.pause()
        }
        self.player.replaceCurrentItem(with: playerItem)
        self.currentItemAddObserver()
    }
    /// 停止  多用于退出界面时
    public func stop() {
        self.pause()
        self.isImmediately = false
        self.currentUrl = nil
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    /// 播放
    public func play() {
        if self.seekToZeroBeforePlay {
            self.musicSeekToTime(time: 0.0)
            self.updateCurrentPlayState(state: .SeekToZeroBeforePlay)
            self.seekToZeroBeforePlay = false
        }
        UIDevice.current.isProximityMonitoringEnabled = true
        self.isPlay = true
        self.player.play()
        self.updateCurrentPlayState(state: .Playing)
        // 暂停是改了 播放速率 播放时及时改变播放倍速
        if self.playerItem != nil {
            self.enableAudioTracks(enable: true, playerItem: self.playerItem!)
        }
        self.player.rate = self.playSpeed
        self.setNowPlayingInfo()
    }
    /// 暂停
    public func pause() {
        self.isPlay = false
        UIDevice.current.isProximityMonitoringEnabled = false
        self.updateCurrentPlayState(state: .Pause)
        player.pause()
        self.setNowPlayingInfo()
    }
    /// 下一首
    public func next() {
        switch self.playType {
        case .list:
            let index = self.currentIndex + 1
            let count = self.musicArray.count
            // 列表已经播完
            if index >= count {
                self.currentIndex = 0
                return
            }
            self.changeTheMusicByIndex(index: index)
        case .cycle:
            let index = self.currentIndex + 1
            let count = self.musicArray.count
            // 列表已经播完,循环播放
            if index >= count {
                self.currentIndex = 0
                self.changeTheMusicByIndex(index: 0)
                return
            }
            self.changeTheMusicByIndex(index: index)
        default: break
        }
    }
    /// 上一首
    public func previous() {
        switch self.playType {
        case .list, .cycle:
            let index = self.currentIndex - 1
            // 已经是列表第一首
            if index < 0 {
                self.currentIndex = 0
                self.changeTheMusicByIndex(index: 0)
                return
            }
            self.changeTheMusicByIndex(index: index)
        default: break
        }
    }
    /// 跳到 指定的时间点 播放
    /// - Parameter time: 指定时间点
    public func musicSeekToTime(time: Float) {
        guard let durantion = self.player.currentItem?.duration, !durantion.isIndefinite else { return }
        let interval = CMTimeGetSeconds(durantion)
        self.isSeekingToTime = true
        if interval != 0 {
            let seekTime = CMTimeMake(value: Int64(Float64(time) * interval), timescale: 1)
            self.player.seek(to: seekTime) { (complete) in
                self.isSeekingToTime = false
                self.setNowPlayingInfo()
            }
        } else {
            let seekTime = CMTimeMake(value: 0, timescale: 1)
            self.player.seek(to: seekTime) { (complete) in
                self.isSeekingToTime = false
                self.setNowPlayingInfo()
            }
            self.progress = 0
        }
    }
    /// 设置锁屏时 播放中心的播放信息
    public func setNowPlayingInfo() {
        var info = Dictionary<String,Any>()
        info[MPMediaItemPropertyTitle] = self.currentModel?.name ?? ""
        // 音频图片
        if let named = self.currentModel?.imageUrl {
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize.init(width: 40, height: 40), requestHandler: { (size) -> UIImage in
                return UIImage.init(named: named) ?? UIImage()
            })
        }
        // 总时长
        info[MPMediaItemPropertyPlaybackDuration] = self.durantion
        // 播放时长
        if let duration = self.player.currentItem?.currentTime() {
            info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(duration)
        }
        // 播放速率
        info[MPNowPlayingInfoPropertyPlaybackRate] = self.playSpeed
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    /// 上一首 下一首切换时  以便于播放界面做相应的调整
    /// - Parameter index: 当前播放
    private func changeTheMusicByIndex(index: Int) {
        self.playArray(index: index, isImmediately: true)
        self.delegate?.changeMusicToIndex(index: index)
    }
    /// 实时更新播放状态  全局通知（便于多个地方都用到音频播放，改变播放状态）
    /// - Parameter state: 播放状态
    private func updateCurrentPlayState(state: ZAVPlayerPlayState) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZAVPlayerState),
                                        object: nil,
                                        userInfo: [ZAVPlayerState: state,
                                                   ZAVPlayerCurrentPlayUrl: self.currentUrl ?? "",
                                                   ZAVPlayerPlayType: self.playType])
    }
    /// 格式化时间为字符串
    private func timeFormatted(totalSeconds: Float64) -> String {
        let interval = TimeInterval(totalSeconds)
        return interval.durationText
    }
    /// 当前播放时间
    public var currentTime: String {
        if let current = self.player.currentItem?.currentTime(){
            return timeFormatted(totalSeconds: CMTimeGetSeconds(current))
        }
        return ""
    }
    /// 播放音频总时长
    public var totalTime: String {
        return self.timeFormatted(totalSeconds:self.durantion)
    }
    /// 观察者   播放状态  和  缓冲进度
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = object as? AVPlayerItem else { return }
        switch keyPath {
        case "status":
            switch item.status {
            case AVPlayerItem.Status.readyToPlay:
                if isImmediately {
                    self.play()
                }else{
                    self.setNowPlayingInfo()
                }
            case AVPlayerItem.Status.failed,AVPlayerItem.Status.unknown:
                self.updateCurrentPlayState(state: .NotPlay)
            }
        case "loadedTimeRanges":
            let array = item.loadedTimeRanges
            let timeRange = array.first?.timeRangeValue
            guard let start = timeRange?.start , let end = timeRange?.end else { return }
            let startSeconds = CMTimeGetSeconds(start)
            let durationSeconds = CMTimeGetSeconds(end)
            let totalBuffer = startSeconds + durationSeconds
            let total = self.durantion
            if totalBuffer != 0  && total != 0 {
                self.delegate?.updateBufferProgress(progress: Float(totalBuffer) / Float(total))
            }
        default: break
        }
    }
}
extension TimeInterval {
    fileprivate var durationText: String {
        if self.isNaN || self.isInfinite {
            return "00:00"
        }
        let hours = Int(self.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(self.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}


