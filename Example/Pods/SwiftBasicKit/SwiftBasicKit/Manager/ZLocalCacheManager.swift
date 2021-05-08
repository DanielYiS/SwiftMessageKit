
import UIKit
import BFKit
import CryptoSwift
import SwiftBasicKit

/// 本地本地缓存文件夹
fileprivate let kLocalCacheDataKey = "LocalCacheDataFile"

/// 本地缓存数据管理
public class ZLocalCacheManager: NSObject {
    
    /// 保存数据到本读指定文件路径
    public static func func_setlocaldata(dic: [String: Any], key: String) {
        
        let filePath = ZLocalCacheManager.createLocalDataFolder().appendingPathComponent((key + ZSettingKit.shared.userId).md5()).appendingPathExtension("plist")
        do {
            let fileData = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            try fileData.write(to: filePath)
        } catch {
            BFLog.error("Error Writing file: \(error.localizedDescription)")
        }
    }
    /// 读取本读指定文件路径的数据
    public static func func_getlocaldata(key: String) -> [String: Any]? {
        
        let filePath = ZLocalCacheManager.createLocalDataFolder().appendingPathComponent((key + ZSettingKit.shared.userId).md5()).appendingPathExtension("plist")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            return nil
        }
        do {
            let fileData = try Data.init(contentsOf: filePath)
            let jsonData = try? JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions.mutableContainers)
            return jsonData as? [String: Any]
        } catch {
            BFLog.error("Error Writing file: \(error.localizedDescription)")
        }
        return nil
    }
    /// 创建本地数据的文件夹
    static fileprivate func createLocalDataFolder() -> URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let folder = cachesDirectory.appendingPathComponent(kLocalCacheDataKey)
        if !FileManager.default.fileExists(atPath: folder.path) {
            do {
                try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                BFLog.error("error:\(error)")
            }
        }
        return folder
    }
}
