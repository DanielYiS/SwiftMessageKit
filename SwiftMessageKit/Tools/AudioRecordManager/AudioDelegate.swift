
import UIKit

/**
 *  录音的 delegate 函数
 */
protocol RecordAudioDelegate: class {
    /**
     更新进度 , 0.0 - 9.0, 浮点数
     */
    func audioRecordUpdateMetra(_ metra: Float, audioTimeInterval: Int32)
    
    /**
     录音太短
     */
    func audioRecordTooShort()
    
    /**
     录音失败
     */
    func audioRecordFailed()
    
    /**
     取消录音
     */
    func audioRecordCanceled()
    
    /**
     录音完成
     
     - parameter recordTime:        录音时长
     - parameter uploadAmrData:     上传的 amr Data
     - parameter filepath:          amr 音频数据的本地地址
     */
    func audioRecordFinish(_ uploadAmrData: Data, recordTime: Float, filepath: URL)
}
/**
 *  播放的 delegate 函数
 */
protocol PlayAudioDelegate: class {
    /**
     播放开始
     */
    func audioPlayStart()
    
    /**
     播放完毕
     */
    func audioPlayFinished()
    
    /**
     播放失败
     */
    func audioPlayFailed()
    
    /**
     播放被中断
     */
    func audioPlayInterruption()
}
