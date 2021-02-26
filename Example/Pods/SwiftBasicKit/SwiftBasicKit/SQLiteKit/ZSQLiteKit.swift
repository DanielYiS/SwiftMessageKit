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
        ZSQLiteKit.getMaxModel(model: &model, column: ZModelVersion.Columns.version.rawValue)
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
        ZSQLiteKit.setModel(model: model!)
    }
}
extension ZSQLiteKit {
    /// 获取数据对象
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getModel<T: Record>(model: inout T?, filter: String, values: [Any]) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    model = try T.filter(sql: filter, arguments: arguments).fetchOne(db)
                } else {
                    model = try T.filter(sql: filter).fetchOne(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取数据对象
    /// column 字段名称
    public static func getMaxModel<T: Record>(model: inout T?, column: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                if try db.tableExists(T.databaseTableName) {
                    model = try T.select(max(Column.init(column))).fetchOne(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取指定条件纪录数
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getArrayCount<T: Record>(model: inout T?, count: inout Int, filter: String, values: [Any])  {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    count = try T.filter(sql: filter, arguments: arguments).fetchCount(db)
                } else {
                    count = try T.filter(sql: filter).fetchCount(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取制定条件对象集合
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getArrayWhere<T: Record>(models: inout [T]?, filter: String, values: [Any], order: String? = nil, page: Int = 0) {
        do {
            let size = ZKey.number.pageCount
            try ZSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    if let strOrder = order {
                        models = try T.filter(sql: filter, arguments: arguments).order(Column(strOrder).desc).limit(page * size, offset: size).fetchAll(db)
                    } else {
                        models = try T.filter(sql: filter, arguments: arguments).limit(page * size, offset: size).fetchAll(db)
                    }
                } else {
                    if let strOrder = order {
                        models = try T.filter(sql: filter).limit(page * size, offset: size).order(Column(strOrder).desc).fetchAll(db)
                    } else {
                        models = try T.filter(sql: filter).limit(page * size, offset: size).fetchAll(db)
                    }
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取所有对象
    public static func getArrayAll<T: Record>(models: inout [T]?) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 设置对象
    public static func setModel<T: Record>(model: T) {
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                try model.save(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 设置对象集合
    public static func setModels<T: Record>(models: [T]) {
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                for model in models {
                    try model.save(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改对象
    public static func updModel<T: Record>(model: T) {
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                try model.update(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 删除对象
    @discardableResult
    public static func delModel<T: Record>(model: T) -> Bool {
        var success: Bool = false
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                success = try model.delete(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
        return success
    }
    /// 删除某表数据
    @discardableResult
    public static func delModelAll<T: Record>(_ : T) -> Int {
        var count: Int = 0
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                count = try T.deleteAll(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
        return count
    }
    /// 获取用户行为集合
    public static func getArrayBehavior<T: ZModelUserBehavior>(models: inout [T]?, type: zUserBehaviorType, page: Int = 0) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db,
                                        sql: "SELECT t1.*,t2.* FROM tb_user_behavior t1 LEFT JOIN tb_user t2 ON t1.behavior_userid = t2.userid WHERE t1.login_userid = ? AND t1.behavior_type = ?  ORDER BY t1.behavior_time DESC LIMIT ? OFFSET ?",
                                        arguments: [ZSettingKit.shared.userId, type, ZKey.number.pageCount, page * ZKey.number.pageCount])
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
}
