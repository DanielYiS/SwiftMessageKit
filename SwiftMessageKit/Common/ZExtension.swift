import UIKit

extension Notification {
    public struct Names {
        public static let AgoraUploadImage = Notification.Name.init(rawValue: "AgoraUploadImage")
        public static let AgoraUploadFile = Notification.Name.init(rawValue: "AgoraUploadFile")
        public static let AgoraSendMessage = Notification.Name.init(rawValue: "MessageUnReadCount")
    }
}
extension NSNotification {
    public struct Names {
        public static let AgoraUploadImage = Notification.Name.init(rawValue: "AgoraUploadImage")
        public static let AgoraUploadFile = Notification.Name.init(rawValue: "AgoraUploadFile")
        public static let AgoraSendMessage = Notification.Name.init(rawValue: "MessageUnReadCount")
    }
}
