
import UIKit
import SwiftBasicKit

/// 声网文件管理
public class ZAgoraFileApi: NSObject {
    
    /// 上传一张图片
    public final func uploadImage(_ imageUrl: URL, receive: ZModelMessageUser, messageid: String) {
        //var capacity = Int64(arc4random())
        //let pointer = withUnsafePointer(to: &capacity) { return $0 }
        //let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        
        NotificationCenter.default.post(name: Notification.Names.AgoraUploadImage, object: ["path": imageUrl, "receive": receive, "messageid": messageid])
    }
    /// 上传一个文件
    public final func uploadFile(_ fileUrl: URL, receive: ZModelMessageUser, messageid: String) {
        //var capacity = Int64(arc4random())
        //let pointer = withUnsafePointer(to: &capacity) { return $0 }
        //let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        
        NotificationCenter.default.post(name: Notification.Names.AgoraUploadFile, object: ["path": fileUrl, "receive": receive, "messageid": messageid])
    }
}
