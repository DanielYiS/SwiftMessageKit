
import UIKit
import BFKit
import GRDB.Swift

extension ZSQLiteKit {
    
    /// 获取未读数量
    public static func getMessageUnreadCount(count: inout Int) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                let row = try Row.fetchOne(db, sql: "SELECT COUNT(t1.message_id) as unReadCount FROM tb_message t1 LEFT JOIN tb_message_user t2 ON t1.message_userid = t2.userid WHERE t1.login_userid = ? AND t1.message_read_state = 0 AND t2.role != ?", arguments: [ZSettingKit.shared.userId, ZSettingKit.shared.role])
                count = Int(row?["unReadCount"] as? Int64 ?? 0)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取聊天记录列表
    public static func getArrayMessageRecord<T: ZModelMessage>(models: inout [T]?, page: Int) {
        do {
            let loginuserid = ZSettingKit.shared.userId
            if ZSettingKit.shared.role == .anchor {
                let sql = "SELECT t1.* FROM tb_message_user t1 WHERE t1.login_userid = ? AND t1.role != ? GROUP BY t1.userid ORDER BY t1.role DESC, t1.message_time DESC LIMIT \(kPageCount) OFFSET \((page - 1) * kPageCount)"
                try ZSQLiteKit.shared.connection?.write({ db in
                    models = try T.fetchAll(db, sql: sql, arguments: [loginuserid, ZSettingKit.shared.role])
                })
            } else {
                let sql = "SELECT t1.* FROM tb_message_user t1 WHERE t1.login_userid = ? GROUP BY t1.userid ORDER BY t1.role DESC, t1.message_time DESC LIMIT \(kPageCount) OFFSET \((page - 1) * kPageCount)"
                try ZSQLiteKit.shared.connection?.write({ db in
                    models = try T.fetchAll(db, sql: sql, arguments: [loginuserid])
                })
            }
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取指定某人的消息对话列表
    public static func getArrayMessage<T: ZModelMessage>(models: inout [T]?, userid: String, time: Double = Date().timeIntervalSince1970) {
        do {
            let loginuserid = ZSettingKit.shared.userId
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db, sql: "SELECT t1.* FROM tb_message t1 WHERE t1.message_userid = ? AND t1.login_userid = ? AND t1.message_time < ? ORDER BY t1.message_time DESC LIMIT ? OFFSET 0", arguments: [userid, loginuserid, time, kPageCount])
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
            NotificationCenter.default.post(name: Notification.Names.MessageUnReadCount, object: nil)
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改某条消息为已读
    public static func setMessageUnRead(messageid: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                try db.execute(sql: "UPDATE tb_message SET message_read_state = 1 WHERE message_id = ?", arguments: [messageid])
            })
            NotificationCenter.default.post(name: Notification.Names.MessageUnReadCount, object: nil)
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
    /// 删除指定某人的消息对话
    public static func delMessageRecord(userid: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                try db.execute(sql: "DELETE tb_message_user WHERE userid = ? AND login_userid = ?", arguments: [userid, ZSettingKit.shared.userId])
                try db.execute(sql: "DELETE tb_message WHERE message_userid = ? AND login_userid = ?", arguments: [userid, ZSettingKit.shared.userId])
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
}
