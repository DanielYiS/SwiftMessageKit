
import UIKit
import BFKit
import CryptoSwift

fileprivate let kAudioFileTypeWav = "wav"
fileprivate let kAudioFileTypeMp3 = "mp3"
fileprivate let kAudioFileTypeMp4 = "mp4"
fileprivate let kAudioFileTypeAmr = "amr"
fileprivate let kImageFileTypeJpeg = "jpeg"

/// 本地文件管理类
public struct ZLocalFileApi {
    
    /// 图片路径  不包含后缀
    public static let imageFileFolder = ZLocalFileApi.createFolder(folderName: "ImageFileFolder")
    /// amr文件路径  不包含后缀
    public static let amrRecordFolder = ZLocalFileApi.createFolder(folderName: "AudioAmrRecord")
    /// wav文件路径  不包含后缀
    public static let wavRecordFolder = ZLocalFileApi.createFolder(folderName: "AudioWavRecord")
    /// mp3文件路径  不包含后缀
    public static let mp3RecordFolder = ZLocalFileApi.createFolder(folderName: "AudioMp3Record")
    /// wav文件路径  不包含后缀
    public static let mp4RecordFolder = ZLocalFileApi.createFolder(folderName: "AudioMp4Record")
    /// 临时文件路径  不包含后缀
    public static let tempFileFolder = ZLocalFileApi.createFolder(folderName: "TempFileFolder")
    
    /// 生成一个文件地址 war
    /// - returns: 文件路径，包含后缀
    public static var wavFilePath: URL {
        return ZLocalFileApi.wavRecordFolder.appendingPathComponent(kRandomId).appendingPathExtension(kAudioFileTypeWav)
    }
    /// 生成一个文件地址 amr
    /// - returns: 文件路径，包含后缀
    public static var armFilePath: URL {
        return ZLocalFileApi.amrRecordFolder.appendingPathComponent(kRandomId).appendingPathExtension(kAudioFileTypeAmr)
    }
    /// 生成一个文件地址 mp3
    /// - returns: 文件路径，包含后缀
    public static var mp3FilePath: URL {
        return ZLocalFileApi.mp3RecordFolder.appendingPathComponent(kRandomId).appendingPathExtension(kAudioFileTypeMp3)
    }
    /// 生成一个文件地址 mp4
    /// - returns: 文件路径，包含后缀
    public static var mp4FilePath: URL {
        return ZLocalFileApi.mp4RecordFolder.appendingPathComponent(kRandomId).appendingPathExtension(kAudioFileTypeMp4)
    }
    /// 生成一个文件地址 image
    /// - returns: 图片路径，包含后缀
    public static var imagePath: URL {
        return ZLocalFileApi.imageFileFolder.appendingPathComponent(kRandomId).appendingPathExtension(kImageFileTypeJpeg)
    }
    /// 移动文件
    /// - parameter originPath:     原路径
    /// - parameter toPath:         目标路径
    /// - returns: 目标路径
    @discardableResult
    public static func moveFile(originPath: URL, toPath: URL) -> Bool {
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
    public static func copyFile(originPath: URL, toPath: URL) -> Bool {
        do {
            try FileManager.default.copyItem(at: originPath, to: toPath)
            return true
        } catch let error {
            BFLog.error("copyFile error:\(error.localizedDescription)")
        }
        return false
    }
    /// 保存文件
    /// - parameter fileData:   数据源
    /// - parameter toPath:     目标路径
    /// - returns: 目标路径
    @discardableResult
    public static func saveFile(fileData: Data, toPath: URL) -> Bool {
        do {
            try fileData.write(to: toPath)
            return true
        } catch {
            BFLog.error("save file Error: \(error.localizedDescription)")
        }
        return false
    }
    /// 保存图片
    /// - parameter image:  数据源
    /// - parameter toPath: 目标路径
    /// - returns: 目标路径
    @discardableResult
    public static func saveImage(image: UIImage, toPath: URL) -> Bool {
        do {
            guard let fileData = image.jpegData(compressionQuality: 0.6) else {
                return false
            }
            try fileData.write(to: toPath)
            return true
        } catch let error {
            BFLog.error("save file Error: \(error.localizedDescription)")
        }
        return false
    }
    /// 删除文件
    /// - parameter path: 路径
    public static func deleteFile(path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error {
            BFLog.info("could not remove error: \(error.localizedDescription)")
        }
    }
    /// 循环删除目录内的文件
    /// - parameter folder: 目录路径
    public static func deleteFiles(folderPath: String) {
        guard let files = FileManager.default.subpaths(atPath: folderPath) else {
            return
        }
        for file in files {
            let path = folderPath + "/\(file)"
            BFLog.info("removing: \(path)")
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch let error {
                BFLog.info("could not remove error: \(error.localizedDescription)")
            }
        }
    }
    /// 循环获取目录文件大小
    /// - parameter folderPath: 目录地址
    /// - returns: 目录大小 字节
    public static func folderSize(folderPath: String) -> UInt64 {
        if !FileManager.default.fileExists(atPath: folderPath) { return 0 }
        var fileSize: UInt64 = 0
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            for file in files {
                let path = folderPath + "/\(file)"
                fileSize = fileSize + ZLocalFileApi.fileSize(filePath: path)
            }
        } catch let error {
            BFLog.info("folderSize error: \(error.localizedDescription)")
        }
        return fileSize
    }
    /// 获取文件大小
    /// - parameter filePath: 文件地址
    /// - returns: 文件大小 字节
    public static func fileSize(filePath: String) -> UInt64 {
        if !FileManager.default.fileExists(atPath: filePath) { return 0 }
        var fileSize: UInt64 = 0
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            fileSize = (attr[FileAttributeKey.size] as? UInt64) ?? 0
            
            let dict = attr as NSDictionary
            fileSize = dict.fileSize()
        } catch let error {
            BFLog.info("fileSize error: \(error.localizedDescription)")
        }
        return fileSize
    }
    /// 创建本地文件的文件夹
    /// - parameter filename: 目录名称
    /// - returns: 目标路径
    private static func createFolder(folderName: String) -> URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let folder = cachesDirectory.appendingPathComponent(folderName)
        if !FileManager.default.fileExists(atPath: folder.path) {
            do {
                try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                BFLog.error("createLocalDataFolder error:\(error.localizedDescription)")
            }
        }
        return folder
    }
}
