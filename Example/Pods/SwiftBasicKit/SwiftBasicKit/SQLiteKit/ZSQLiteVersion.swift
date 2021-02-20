import UIKit
import BFKit
import GRDB.Swift

/// 数据库版本管理
struct ZSQLiteVersion {
    
    /// 当前App本地版本 - 每次修改数据库都需要+1
    static let dbVersion: Int = 1
    /// 创建数据表 Version 0
    static func createTableVersion() {
        do {
            try ZSQLiteKit.shared.connection?.write { db in
                try db.create(table: ZModelVersion.databaseTableName, ifNotExists: true, body: { t in
                    t.column("version", .integer).notNull().defaults(to: 0).indexed()
                    t.column("content", .text).notNull().defaults(to: "")
                    t.primaryKey(["version"])
                })
                try db.create(table: ZModelUserBase.databaseTableName, ifNotExists: true, body: { t in
                    t.column("userid", .text).notNull().defaults(to: "").indexed()
                    t.column("token", .text).notNull().defaults(to: "")
                    t.column("nickname", .text).notNull().defaults(to: "")
                    t.column("password", .text).notNull().defaults(to: "")
                    t.column("role", .integer).notNull().defaults(to: zUserRole.user)
                    t.column("gender", .integer).notNull().defaults(to: zUserGender.male)
                    t.column("avatar", .text).notNull().defaults(to: "")
                    t.column("age", .integer).notNull().defaults(to: 25)
                    t.column("birthday", .text).notNull().defaults(to: "")
                    t.column("height", .integer).notNull().defaults(to: 0)
                    t.column("weight", .integer).notNull().defaults(to: 0)
                    t.column("bodytype", .text).notNull().defaults(to: "")
                    t.column("belong", .text).notNull().defaults(to: "")
                    t.column("country", .text).notNull().defaults(to: "")
                    t.column("province", .text).notNull().defaults(to: "")
                    t.column("city", .text).notNull().defaults(to: "")
                    t.column("email", .text).notNull().defaults(to: "")
                    t.column("tel", .text).notNull().defaults(to: "")
                    t.column("introduction", .text).notNull().defaults(to: "")
                    t.column("balance", .double).notNull().defaults(to: 0)
                    t.column("photos", .text).notNull().defaults(to: "")
                    t.column("videos", .text).notNull().defaults(to: "")
                    t.column("show_location", .text).notNull().defaults(to: true)
                    t.primaryKey(["userid"])
                })
                try db.create(table: ZModelMessage.databaseTableName, ifNotExists: true, body: { t in
                    t.column("message_id", .text).notNull().defaults(to: "")
                    t.column("message_userid", .text).notNull().defaults(to: "")
                    t.column("message", .text).notNull().defaults(to: "")
                    t.column("message_type", .integer).notNull().defaults(to: zMessageType.text)
                    t.column("message_time", .double).notNull().defaults(to: 0)
                    t.column("message_direction", .integer).notNull().defaults(to: zMessageDirection.send)
                    t.column("message_read_state", .boolean).notNull().defaults(to: false)
                    t.column("message_file_id", .text).notNull().defaults(to: "")
                    t.column("message_file_path", .text).notNull().defaults(to: "")
                    t.column("message_call_count", .integer).notNull().defaults(to: 0)
                    t.column("message_can_call_back", .boolean).notNull().defaults(to: false)
                    t.column("login_userid", .text).notNull().defaults(to: "").indexed()
                    t.primaryKey(["message_id"])
                })
            }
        } catch {
            BFLog.error("createdb version error: \(error.localizedDescription)")
        }
    }
    /// 创建数据表 Version 1
    static func createTableVersion1() {
        do {
            try ZSQLiteKit.shared.connection?.write { db in
            
            }
        } catch {
            BFLog.error("createdb version error: \(error.localizedDescription)")
        }
    }
}
