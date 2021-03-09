import UIKit
import HandyJSON
import GRDB.Swift

/// 用户行为 - 关注，喜欢，拉黑，收藏
public class ZModelUserBehavior: ZModelBase {
    
    public override class var databaseTableName: String { "tb_user_behavior" }
    enum Columns: String, ColumnExpression {
        case  behavior_userid, behavior_time, behavior_type, login_userid
    }
    
    public var behavior_user: ZModelUserBase?
    public var behavior_userid: String = ""
    public var behavior_time: Double = Date.init().timeIntervalSince1970
    public var behavior_type: zUserBehaviorType = .none
    public var login_userid: String = ZSettingKit.shared.userId
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? ZModelUserBehavior else {
            return
        }
        if let user = model.behavior_user {
            self.behavior_user = ZModelUserBase.init(instance: user)
        }
        self.behavior_userid = model.behavior_userid
        self.behavior_time = model.behavior_time
        self.behavior_type = model.behavior_type
        self.login_userid = model.login_userid
    }
    public required init(row: Row) {
        super.init(row: row)
        
        if let _ = row["userid"] {
            self.behavior_user = ZModelUserBase.init(row: row)
        }
        self.behavior_userid = row[Columns.behavior_userid] ?? ""
        self.behavior_time = row[Columns.behavior_time] ?? 0
        self.behavior_type = row[Columns.behavior_type] ?? .none
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.behavior_userid] = self.behavior_userid
        container[Columns.behavior_time] = self.behavior_time
        container[Columns.behavior_type] = self.behavior_type
        container[Columns.login_userid] = self.login_userid
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
