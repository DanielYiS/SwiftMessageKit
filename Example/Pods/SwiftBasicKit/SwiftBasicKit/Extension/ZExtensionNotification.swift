import UIKit
import BFKit

extension Notification {
    public struct Names {
        /// 登录状态改变
        public static let LoginExpired = Notification.Name.init(rawValue: "LoginExpired")
        /// 网络请求开始
        public static let ApiRequestStart = Notification.Name.init(rawValue: "ApiRequestStart")
        /// 网络请求成功
        public static let ApiRequestSuccess = Notification.Name.init(rawValue: "ApiRequestSuccess")
        /// 网络请求错误
        public static let ApiRequestError = Notification.Name.init(rawValue: "ApiRequestError")
        /// 消息未读数量
        public static let MessageUnReadCount = Notification.Name.init(rawValue: "MessageUnReadCount")
        /// 接收到聊天消息
        public static let ReceivedNewMessage = Notification.Name.init(rawValue: "ReceivedNewMessage")
        /// 接收到事件消息
        public static let ReceivedEventMessage = Notification.Name.init(rawValue: "ReceivedEventMessage")
        /// 显示用户详情页面
        public static let ShowUserDetailVC = Notification.Name.init(rawValue: "ShowUserDetailVC")
        /// 显示充值提醒页面
        public static let ShowRechargeReminderVC = Notification.Name.init(rawValue: "ShowRechargeReminderVC")
        /// 声网上传一张图片
        public static let AgoraUploadImage = Notification.Name.init(rawValue: "AgoraUploadImage")
        /// 声网上传一个文件
        public static let AgoraUploadFile = Notification.Name.init(rawValue: "AgoraUploadFile")
        /// 声网发送一条消息
        public static let AgoraSendMessage = Notification.Name.init(rawValue: "AgoraSendMessage")
    }
}
extension NotificationCenter {
    public static func post(name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}
