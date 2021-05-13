
import UIKit
import BFKit
import AVKit
import AVFoundation

/// 播放录制音频代理协议
public protocol ZAudioPlayerDelegate: class {
    func audioPlayError()
    func audioPlayFinish()
    func audioPlayProgress(currentTime: Float, duration: Float)
}
/// 播放录制音频播放状态
public enum AudioPlayerState {
    case playing
    case pause
    case stopped
}
/// 播放录制音频管理类
public class ZAudioPlayerManager: NSObject {
    
    public static let shared = ZAudioPlayerManager()
    public var state: AudioPlayerState = .stopped
    open weak var delegate: ZAudioPlayerDelegate?
    
    private var currentTime: Float = 0
    private var totalTime: Float = 1
    private var audioPlayer: AVAudioPlayer?
    private var playerPath: String = ""
    private var progressTimer: Timer?
    
    deinit {
        self.audioPlayer?.stop()
        self.audioPlayer = nil
    }
    public override init() {
        super.init()
    }
    public final func playSound(path: String) {
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        try? session.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
        self.stopSound()
        self.playerPath = path
        BFLog.debug("start player path: \(self.playerPath)")
        let url = URL.init(fileURLWithPath: path, isDirectory: true)
        BFLog.debug("start player url: \(url.absoluteString)")
        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            self.delegate?.audioPlayError()
            return
        }
        audioPlayer = player
        audioPlayer?.delegate = self
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        state = .playing
        startProgressTimer()
    }
    public final func pauseSound() {
        audioPlayer?.pause()
        state = .pause
        progressTimer?.invalidate()
        progressTimer = nil
    }
    public final func stopSound() {
        audioPlayer?.stop()
        state = .stopped
        progressTimer?.invalidate()
        progressTimer = nil
        audioPlayer = nil
    }
    @objc private func didFireProgressTimer(_ timer: Timer) {
        guard let player = audioPlayer else {
            return
        }
        BFLog.debug("audioPlayProgress currentTime: \(player.currentTime), duration: \(player.duration)")
        self.delegate?.audioPlayProgress(currentTime: Float(player.currentTime), duration: Float(player.duration))
    }
    private func startProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
        progressTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.didFireProgressTimer(_:)), userInfo: nil, repeats: true)
    }
}
extension ZAudioPlayerManager: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopSound()
        self.delegate?.audioPlayFinish()
        BFLog.debug("audioPlayerDidFinishPlaying successfully: \(flag)")
    }
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        stopSound()
        self.delegate?.audioPlayError()
        BFLog.debug("audioPlayerDecodeErrorDidOccur error: \(error?.localizedDescription)")
    }
}
