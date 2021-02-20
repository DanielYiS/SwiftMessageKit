import UIKit
import BFKit
import GRDB.Swift

/// 本地化数据库操作
public class ZSQLiteKit: NSObject {
    
    // 数据库地址
    private let dbPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appendingPathComponent("KitDatabase.sqlite") ?? "KitDatabase.sqlite"
    /// 连接数据库
    private var dbQueue: DatabaseQueue?
    /// 单例模式
    public static let shared = ZSQLiteKit()
    /// 连接池
    public var connection: DatabaseQueue? {
        return self.dbQueue
    }
    /// 打开数据库
    public final func open() {
        if self.dbQueue == nil {
            do {
                var configuration = Configuration()
                configuration.readonly = false
                self.dbQueue = try DatabaseQueue.init(path: self.dbPath, configuration: configuration)
            } catch {
                BFLog.error("create DatabaseQueue error: \(error.localizedDescription)")
            }
        }
        self.checkDBVersion()
    }
    /// 关闭数据库
    public final func close() {
        self.dbQueue?.releaseMemory()
        self.dbQueue = nil
    }
    /// 检测版本
    private final func checkDBVersion() {
        if self.dbQueue == nil {
            return
        }
        // 当前App安装的数据库版本
        var model: ZModelVersion?
        ZSQLiteExecute.getMaxModel(model: &model, column: ZModelVersion.Columns.version.rawValue)
        if let version = model {
            switch version.version {
            case 1:
                ZSQLiteVersion.createTableVersion1()
            default: break
            }
        } else {
            model = ZModelVersion.init()
            ZSQLiteVersion.createTableVersion()
            ZSQLiteVersion.createTableVersion1()
        }
        model?.version = ZSQLiteVersion.dbVersion
        ZSQLiteExecute.setModel(model: model!)
    }
}
