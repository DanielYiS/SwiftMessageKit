
import UIKit
import SwiftBasicKit

/// 声网文件管理
open class ZAgoraFileApi: NSObject {
    
    /// 上传一张图片
    final func uploadImage(_ imageUrl: URL, receive: ZModelMessageUser, messageid: String) {
        var capacity = Int64(arc4random())
        let pointer = withUnsafePointer(to: &capacity) { return $0 }
        let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        
        NotificationCenter.default.post(name: Notification.Names.AgoraUploadImage, object: ["path": imageUrl.path, "request": request])
    }
    /// 上传一个文件
    final func uploadFile(_ fileUrl: URL, receive: ZModelMessageUser, messageid: String) {
        var capacity = Int64(arc4random())
        let pointer = withUnsafePointer(to: &capacity) { return $0 }
        let request = UnsafeMutablePointer<Int64>.init(mutating: pointer)
        
        NotificationCenter.default.post(name: Notification.Names.AgoraUploadFile, object: ["path": fileUrl.path, "request": request])
    }
}
