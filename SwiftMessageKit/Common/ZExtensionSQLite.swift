
import UIKit
import GRDB
import BFKit
import SwiftBasicKit

extension ZSQLiteKit {
    
    /// 获取未读数量
    public static func getMessageUnreadCount(count: inout Int64) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                let row = try Row.fetchOne(db, sql: "SELECT COUNT(t1.message_id) as unReadCount FROM tb_message t1 LEFT JOIN tb_user t2 ON t1.message_userid = t2.userid WHERE t1.login_userid = ? AND t1.message_read_state = 0 AND t2.role != ?", arguments: [ZSettingKit.shared.userId, ZSettingKit.shared.role])
                count = (row?["unReadCount"] as? Int64 ?? 0)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取聊天记录列表
    public static func getArrayMessageRecord<T: ZModelMessage>(models: inout [T]?) {
        do {
            let loginid = ZSettingKit.shared.userId
            try ZSQLiteKit.shared.connection?.write({ db in
                let sql = "SELECT DISTINCT t1.*, t2.*, MAX(t2.message_time) AS message_time_max, (SELECT COUNT(*) FROM tb_message t3 WHERE t3.login_userid = ? AND t3.message_read_state = 0 AND t3.message_userid = t1.userid) AS message_unread_count FROM tb_user t1 LEFT JOIN tb_message t2 ON t1.userid = t2.message_userid WHERE t2.login_userid = ? AND t1.role != ? GROUP BY t1.userid ORDER BY t1.role DESC, message_unread_count DESC, t2.message_time DESC"
                models = try T.fetchAll(db, sql: sql, arguments: [loginid, loginid, ZSettingKit.shared.role])
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取指定某人的消息对话列表
    public static func getArrayMessage<T: ZModelMessage>(models: inout [T]?, userid: String, time: Double = Date.init().timeIntervalSince1970) {
        do {
            let loginid = ZSettingKit.shared.userId
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db, sql: "SELECT t1.* FROM tb_message t1 WHERE t1.message_userid = ? AND t1.login_userid = ? AND t1.message_time < ? ORDER BY t1.message_time DESC LIMIT ? OFFSET 0", arguments: [userid, loginid, time, kPageCount])
            })
            ZSQLiteKit.setMessageUnRead(userid: userid)
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改某个人的消息为已读
    public static func setMessageUnRead(userid: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                try db.execute(sql: "UPDATE tb_message SET message_read_state = 1 WHERE message_userid = ?", arguments: [userid])
            })
            NotificationCenter.post(name: Notification.Names.MessageUnReadCount)
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改呼叫数量 +1
    public static func setMessageCallCount(messageids: [String]) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                var sql = "UPDATE tb_message SET message_call_count = message_call_count + 1 WHERE message_id IN ("
                for id in messageids {
                    sql += "'\(id)',"
                }
                sql.removeLast()
                sql += ");"
                try db.execute(sql: sql)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
}
