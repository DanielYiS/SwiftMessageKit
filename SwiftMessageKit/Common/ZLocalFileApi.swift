
import UIKit
import BFKit.Swift
import CryptoSwift.Swift
import SwiftBasicKit.Swift

fileprivate let kAudioFileTypeWav = "wav"
fileprivate let kAudioFileTypeAmr = "amr"
fileprivate let kImageFileTypeJpeg = "jpeg"
fileprivate let kImageFileTypePng = "png"

/// 本地文件管理类
public class ZLocalFileApi: NSObject {
    
    /// 临时录音文件 wav
    public static let kTempWavRecordPath = ZLocalFileApi.tempFolderPathWithName("wav_temp_record")
    /// 临时录音文件 amr
    public static let kTempAmrFilePath = ZLocalFileApi.tempFolderPathWithName("amr_temp_record")
    /// 聊天图片路径  不包含后缀
    public static let kImageFileFolder = ZLocalFileApi.createLocalDataFolder("ImageFileFolder")
    /// amr文件路径  不包含后缀
    public static let kAmrRecordFolder = ZLocalFileApi.createLocalDataFolder("AudioAmrRecord")
    /// wav文件路径  不包含后缀
    public static let kWavRecordFolder = ZLocalFileApi.createLocalDataFolder("AudioWavRecord")
    /// 临时文件路径  不包含后缀
    public static let kTempFileFolder = ZLocalFileApi.createLocalDataFolder("TempFileFolder")
    
    /// 生成一个临时文件名称
    public static func tempFileName() -> String {
        return "\(Date.timeIntervalBetween1970AndReferenceDate)\(ZSettingKit.shared.userId)\(arc4random())".md5()
    }
    /// 生成一个临时文件 war
    /// - returns: 文件名称，包含后缀
    public static func warFileName() -> String {
        return ZLocalFileApi.tempFileName() + kAudioFileTypeWav
    }
    /// 生成一个临时文件 amr
    /// - returns: 文件名称，包含后缀
    public static func amrFileName() -> String {
        return ZLocalFileApi.tempFileName() + kAudioFileTypeAmr
    }
    /// 返回 temp 的完整路径
    /// - parameter folderName: 文件名字，不包含后缀
    /// - returns: 返回路径
    @discardableResult
    private static func tempFolderPathWithName(_ folderName: String) -> URL {
        return ZLocalFileApi.kTempFileFolder.appendingPathComponent(folderName)
    }
    /// 返回 temp wav  的完整路径
    /// - parameter fileName: 文件名字，包含后缀
    /// - returns: 返回路径
    @discardableResult
    public static func tempWavPathWithName(_ fileName: String) -> URL {
        return ZLocalFileApi.kTempFileFolder.appendingPathComponent(fileName).appendingPathExtension(kAudioFileTypeWav)
    }
    /// 返回 temp amr 的完整路径
    /// - parameter fileName: 文件名字，包含后缀
    /// - returns: 返回路径
    @discardableResult
    public static func tempAmrPathWithName(_ fileName: String) -> URL {
        return ZLocalFileApi.kTempFileFolder.appendingPathComponent(fileName).appendingPathExtension(kAudioFileTypeAmr)
    }
    /// 返回 temp file  的完整路径
    /// - returns: 返回路径
    @discardableResult
    public static func tempImagePath() -> URL {
        return ZLocalFileApi.kTempFileFolder.appendingPathComponent(ZLocalFileApi.tempFileName()).appendingPathExtension(kImageFileTypeJpeg)
    }
    /// 返回 temp file  的完整路径
    /// - parameter fileName: 文件名字，包含后缀
    /// - returns: 返回路径
    @discardableResult
    public static func tempFilePath(_ patExtension: String) -> URL {
        return ZLocalFileApi.kTempFileFolder.appendingPathComponent(ZLocalFileApi.tempFileName()).appendingPathExtension(patExtension)
    }
    /// 返回 image 的完整路径
    /// - parameter fileName: 文件名字，包含后缀
    /// - returns: 返回路径
    @discardableResult
    public static func imagePathWithName(_ fileName: String) -> URL {
        return ZLocalFileApi.kImageFileFolder.appendingPathComponent(fileName).appendingPathExtension(kImageFileTypeJpeg)
    }
    /// 返回 amr 的完整路径
    /// - parameter fileName: 文件名字，包含后缀
    /// - returns: 返回路径
    @discardableResult
    public static func amrPathWithName(_ fileName: String) -> URL {
        return ZLocalFileApi.kAmrRecordFolder.appendingPathComponent(fileName).appendingPathExtension(kAudioFileTypeAmr)
    }
    /// 返回 wav 的完整路径
    /// - parameter fileName: 文件名字，包含后缀
    /// - returns: 返回路径
    @discardableResult
    public static func wavPathWithName(_ fileName: String) -> URL {
        return ZLocalFileApi.kWavRecordFolder.appendingPathComponent(fileName).appendingPathExtension(kAudioFileTypeWav)
    }
    /// 移动文件
    /// - parameter originPath:     原路径
    /// - parameter toPath:         目标路径
    /// - returns: 目标路径
    @discardableResult
    public static func moveFile(_ originPath: URL, toPath: URL) -> Bool {
        do {
            try FileManager.default.moveItem(at: originPath, to: toPath)
            return true
        } catch let error {
            BFLog.error("moveFile error:\(error.localizedDescription)")
        }
        return false
    }
    /// 拷贝文件
    /// - parameter originPath:     原路径
    /// - parameter toPath:         目标路径
    /// - returns: 目标路径
    @discardableResult
    public static func copyFile(_ originPath: URL, toPath: URL) -> Bool {
        do {
            try FileManager.default.copyItem(at: originPath, to: toPath)
            return true
        } catch let error {
            BFLog.error("copyFile error:\(error.localizedDescription)")
        }
        return false
    }
    /// 保存文件
    public static func saveFile(_ fileData: Data, toPath: URL) {
        do {
            try fileData.write(to: toPath)
        } catch {
            BFLog.error("save file Error: \(error.localizedDescription)")
        }
    }
    /// 保存图片
    public static func saveImage(_ image: UIImage, toPath: URL) {
        do {
            guard let fileData = image.jpegData(compressionQuality: ZKey.number.pngToJpegCompress) else {
                return
            }
            try fileData.write(to: toPath)
        } catch let error {
            BFLog.error("save file Error: \(error.localizedDescription)")
        }
    }
    /// 创建本地文件的文件夹
    private static func createLocalDataFolder(_ filename: String) -> URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let folder = cachesDirectory.appendingPathComponent(filename)
        if !FileManager.default.fileExists(atPath: folder.path) {
            do {
                try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                BFLog.error("createLocalDataFolder error:\(error.localizedDescription)")
            }
        }
        return folder
    }
    /// 删除文件
    /// - parameter path: 路径
    public static func deleteFileWithPath(_ path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error {
            BFLog.info("could not remove error: \(error.localizedDescription)")
        }
    }
    /// 删除所有录音文件
    public static func deleteAllRecordingFiles() {
        self.deleteFilesWithPath(ZLocalFileApi.kTempWavRecordPath.path)
        self.deleteFilesWithPath(ZLocalFileApi.kTempAmrFilePath.path)
    }
    /// 删除文件
    /// - parameter path: 路径
    private static func deleteFilesWithPath(_ path: String) {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            let recordings = files.filter( { (name: String) -> Bool in
                return name.hasSuffix(kAudioFileTypeWav)
            })
            for i in 0 ..< recordings.count {
                let path = path + "/" + recordings[i]
                BFLog.info("removing \(path)")
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch let error {
                    BFLog.info("could not remove error: \(error.localizedDescription)")
                }
            }
        } catch let error {
            BFLog.info("could not remove error: \(error.localizedDescription)")
        }
    }
}
