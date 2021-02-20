import UIKit

/// 录音完毕回调
extension ZMessageViewController: RecordAudioDelegate {
    
    /// 更新麦克风的音量大小
    func audioRecordUpdateMetra(_ metra: Float, audioTimeInterval: Int32) {
        self.viewRecordAudio.updateMetersValue(metra, audioTimeInterval)
    }
    /// 录音太短
    func audioRecordTooShort() {
        self.viewRecordAudio.messageTooShort()
    }
    /// 录音完成
    /// - parameter recordTime:        录音时长
    /// - parameter uploadAmrData:     上传的 amr Data
    /// - parameter filepath:          amr 音频数据的本地文件地址
    func audioRecordFinish(_ uploadAmrData: Data, recordTime: Float, filepath: URL) {
        self.viewRecordAudio.endRecord()
        self.startSendAudio(uploadAmrData, recordTime, filepath)
    }
    /// 录音失败
    func audioRecordFailed() {
        self.viewRecordAudio.endRecord()
        ZProgressHUD.showMessage(self, L10n.errorRecording)
    }
    /// 取消录音
    func audioRecordCanceled() {
        self.viewRecordAudio.endRecord()
    }
}
