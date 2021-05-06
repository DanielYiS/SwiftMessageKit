
import UIKit
import SwiftBasicKit

/// 声网发送消息
public class ZAgoraMessageApi: NSObject {
    
    public static let shared = ZAgoraMessageApi.init()
    /// 准备发送文本消息
    public final func sendTextMessage(_ text: String, receive: ZModelMessageUser, messageid: String) {
        NotificationCenter.default.post(name: Notification.Names.AgoraSendMessage, object: ["text": text, "receive": receive, "messageid": messageid])
    }
    /// 准备发送图片消息
    public final func sendImageMessage(_ mediaId: String, receive: ZModelMessageUser, messageid: String) {
        NotificationCenter.default.post(name: Notification.Names.AgoraSendMessage, object: ["imageId": mediaId, "receive": receive, "messageid": messageid])
    }
    /// 准备发送文件消息
    public final func sendFileMessage(_ mediaId: String, receive: ZModelMessageUser, messageid: String) {
        NotificationCenter.default.post(name: Notification.Names.AgoraSendMessage, object: ["fileId": mediaId, "receive": receive, "messageid": messageid])
    }
}
