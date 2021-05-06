import UIKit
import HandyJSON
import GRDB.Swift

/// 自定义消息对象
public class ZModelMessage: ZModelBase {
    
    public override class var databaseTableName: String { "tb_message" }
    enum Columns: String, ColumnExpression {
        case message_userid, login_userid, message_id, message, message_type, message_direction, message_time, message_send_state, message_read_state, message_unread_count, message_file_id, message_file_path, message_file_size, message_can_call_back, message_call_count
    }
    public var message_user: ZModelUserBase?
    public var message_user_login: ZModelUserLogin?
    public var message_userid: String = ""
    public var message_id: String = ""
    public var message_serviceid: Int = 0
    public var message_issave: Bool = true
    public var message_json: String = ""
    public var message: String = ""
    public var message_type: zMessageType = .text
    public var message_direction: zMessageDirection = .send
    public var message_time: Double = 0.0
    /// 0 本地 1 支付未发送 2 支付发送成功
    public var message_send_state: Int = 0
    public var message_read_state: Bool = false
    public var message_unread_count: Int64 = 0
    public var message_file_id: String = ""
    public var message_file_path: String = ""
    public var message_file_size: Double = 0
    public var message_can_call_back: Bool = false
    public var message_call_count: Int64 = 0
    public var login_userid: String = ZSettingKit.shared.userId
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? ZModelMessage else {
            return
        }
        if let user = model.message_user {
            self.message_user = ZModelUserBase.init(instance: user)
        }
        if let user = model.message_user_login {
            self.message_user_login = ZModelUserLogin.init(instance: user)
        }
        self.message_userid = model.message_userid
        self.login_userid = model.login_userid
        self.message_id = model.message_id
        self.message = model.message
        self.message_type = model.message_type
        self.message_direction = model.message_direction
        self.message_time = model.message_time
        self.message_send_state = model.message_send_state
        self.message_read_state = model.message_read_state
        self.message_unread_count = model.message_unread_count
        self.message_file_id = model.message_file_id
        self.message_file_path = model.message_file_path
        self.message_file_size = model.message_file_size
        self.message_can_call_back = model.message_can_call_back
        self.message_call_count = model.message_call_count
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.message_user = ZModelUserBase.init(row: row)
        self.message_user_login = ZModelUserLogin.init(row: row)
        self.message_userid = row[Columns.message_userid] ?? ""
        self.message_id = row[Columns.message_id] ?? ""
        self.message = row[Columns.message] ?? ""
        self.message_type = row[Columns.message_type] ?? .text
        self.message_direction = row[Columns.message_direction] ?? .send
        self.message_time = row[Columns.message_time] ?? 0
        self.message_send_state = row[Columns.message_send_state] ?? 0
        self.message_read_state = row[Columns.message_read_state] ?? false
        self.message_unread_count = row[Columns.message_unread_count] ?? 0
        self.message_file_id = row[Columns.message_file_id] ?? ""
        self.message_file_path = row[Columns.message_file_path] ?? ""
        self.message_file_size = row[Columns.message_file_size] ?? 0
        self.message_can_call_back = row[Columns.message_can_call_back] ?? false
        self.message_call_count = row[Columns.message_call_count] ?? 0
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.message_userid] = self.message_userid
        container[Columns.login_userid] = self.login_userid
        container[Columns.message_id] = self.message_id
        container[Columns.message] = self.message
        container[Columns.message_type] = self.message_type
        container[Columns.message_direction] = self.message_direction
        container[Columns.message_time] = self.message_time
        container[Columns.message_send_state] = self.message_send_state
        container[Columns.message_read_state] = self.message_read_state
        container[Columns.message_file_id] = self.message_file_id
        container[Columns.message_file_path] = self.message_file_path
        container[Columns.message_file_size] = self.message_file_size
        container[Columns.message_can_call_back] = self.message_can_call_back
        container[Columns.message_call_count] = self.message_call_count
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
