import UIKit
import HandyJSON
import GRDB.Swift

public class ZModelMessageRecord: ZModelBase {
    
    public class override var databaseTableName: String { "tb_message_record" }
    public enum Columns: String, ColumnExpression {
        case userid, email, role, nickname, birthday, gender, avatar, age, message_id, message, message_time, message_type, message_direction, message_can_call_back, message_unread_count, login_userid
    }
    public var message_user: ZModelUserBase?
    public var message_user_login: ZModelUserLogin?
    public var message_id: String = ""
    public var message: String = ""
    public var message_time: Double = 0.0
    public var message_type: zMessageType = .text
    public var message_direction: zMessageDirection = .send
    public var message_file_id: String = ""
    public var message_file_path: String = ""
    public var message_file_size: Double = 0
    public var message_can_call_back: Bool = false
    public var message_unread_count: Int64 = 0
    public var login_userid: String = ZSettingKit.shared.userId
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? ZModelMessageRecord else {
            return
        }
        if let user = model.message_user {
            self.message_user = ZModelUserBase.init(instance: user)
        }
        if let user = model.message_user_login {
            self.message_user_login = ZModelUserLogin.init(instance: user)
        }
        self.message_id = model.message_id
        self.message = model.message
        self.message_time = model.message_time
        self.message_type = model.message_type
        self.message_direction = model.message_direction
        self.message_can_call_back = model.message_can_call_back
        self.message_unread_count = model.message_unread_count
        self.login_userid = model.login_userid
    }
    public required init(row: Row) {
        super.init(row: row)
        self.message_user = ZModelUserBase.init(row: row)
        self.message_user_login = ZModelUserLogin.init(row: row)
        
        self.message_id = row[Columns.message_id] ?? ""
        self.message = row[Columns.message] ?? ""
        self.message_time = row[Columns.message_time] ?? 0
        self.message_type = row[Columns.message_type] ?? .text
        self.message_direction = row[Columns.message_direction] ?? .send
        self.message_can_call_back = row[Columns.message_can_call_back] ?? false
        self.message_unread_count = row[Columns.message_unread_count] ?? 0
        self.login_userid = row[Columns.login_userid] ?? ""
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        if let user = self.message_user {
            container[Columns.userid] = user.userid
            container[Columns.email] = user.email
            container[Columns.nickname] = user.nickname
            container[Columns.role] = user.role
            container[Columns.gender] = user.gender
            container[Columns.avatar] = user.avatar
            container[Columns.age] = user.age
            container[Columns.birthday] = user.birthday
        }
        if let user = self.message_user_login {
            container[Columns.userid] = user.userid
            container[Columns.email] = user.email
            container[Columns.nickname] = user.nickname
            container[Columns.role] = user.role
            container[Columns.gender] = user.gender
            container[Columns.avatar] = user.avatar
            container[Columns.age] = user.age
            container[Columns.birthday] = user.birthday
        }
        container[Columns.message_id] = self.message_id
        container[Columns.message] = self.message
        container[Columns.message_time] = self.message_time
        container[Columns.message_type] = self.message_type
        container[Columns.message_direction] = self.message_direction
        container[Columns.message_can_call_back] = self.message_can_call_back
        container[Columns.login_userid] = self.login_userid
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
