import UIKit
import HandyJSON
import GRDB.Swift

/// 检查版本更新
public class ZModelUpdate: ZModelBase {
    
    public class override var databaseTableName: String { "tb_update" }
    enum Columns: String, ColumnExpression {
        case version, change_log, is_force, status, user_match_price
    }
    /// 最新版本号
    public var version: String = ""
    /// 更新日志
    public var change_log: String = ""
    /// 是否强更
    public var is_force: Bool = false
    /// 是否审核中 1:Dev, 2:Release(过审时用此状态), 3:Prod
    public var status: zAppStatus = .none
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.version = model.version
        self.change_log = model.change_log
        self.is_force = model.is_force
        self.status = model.status
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.version = row[Columns.version] ?? ""
        self.change_log = row[Columns.change_log] ?? ""
        self.is_force = row[Columns.is_force] ?? false
        self.status = row[Columns.status] ?? .none
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.version] = self.version
        container[Columns.change_log] = self.change_log
        container[Columns.is_force] = self.is_force
        container[Columns.status] = self.status
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
