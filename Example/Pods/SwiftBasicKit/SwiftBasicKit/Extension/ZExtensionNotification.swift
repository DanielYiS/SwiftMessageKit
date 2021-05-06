import UIKit
import BFKit

extension Notification {
    public struct Names {
        /// 登录状态改变
        public static let LoginExpired = Notification.Name.init(rawValue: "LoginExpired")
        /// 定时器
        public static let ExecuteTimer = Notification.Name.init(rawValue: "ExecuteTimer")
        /// 消息未读数量
        public static let MessageUnReadCount = Notification.Name.init(rawValue: "MessageUnReadCount")
        /// 余额不足
        public static let InsufficientBalance = Notification.Name.init(rawValue: "InsufficientBalance")
        /// 余额变动
        public static let UserBalanceChange = Notification.Name.init(rawValue: "UserBalanceChange")
        /// 接收到聊天消息
        public static let ReceivedNewMessage = Notification.Name.init(rawValue: "ReceivedNewMessage")
        /// 接收到事件消息
        public static let ReceivedEventMessage = Notification.Name.init(rawValue: "ReceivedEventMessage")
        /// 显示用户详情页面
        public static let ShowUserDetailVC = Notification.Name.init(rawValue: "ShowUserDetailVC")
        /// 显示内购页面
        public static let ShowRechargeVC = Notification.Name.init(rawValue: "ShowRechargeVC")
        /// 显示聊天页面
        public static let ShowChatMessageVC = Notification.Name.init(rawValue: "ShowChatMessageVC")
        /// 显示视频后的对应页面
        public static let ShowVideoEndVC = Notification.Name.init(rawValue: "ShowVideoEndVC")
        /// 隐藏呼叫或视频页面
        public static let DismissCallVideoVC = Notification.Name.init(rawValue: "DismissCallVideoVC")
    }
}
extension NSNotification {
    public struct Names {
        /// 登录状态改变
        public static let LoginExpired = Notification.Name.init(rawValue: "LoginExpired")
        /// 定时器
        public static let ExecuteTimer = Notification.Name.init(rawValue: "ExecuteTimer")
        /// 消息未读数量
        public static let MessageUnReadCount = Notification.Name.init(rawValue: "MessageUnReadCount")
        /// 余额不足
        public static let InsufficientBalance = Notification.Name.init(rawValue: "InsufficientBalance")
        /// 余额变动
        public static let UserBalanceChange = Notification.Name.init(rawValue: "UserBalanceChange")
        /// 接收到聊天消息
        public static let ReceivedNewMessage = Notification.Name.init(rawValue: "ReceivedNewMessage")
        /// 接收到事件消息
        public static let ReceivedEventMessage = Notification.Name.init(rawValue: "ReceivedEventMessage")
        /// 显示用户详情页面
        public static let ShowUserDetailVC = Notification.Name.init(rawValue: "ShowUserDetailVC")
        /// 显示内购页面
        public static let ShowRechargeVC = Notification.Name.init(rawValue: "ShowRechargeVC")
        /// 显示聊天页面
        public static let ShowChatMessageVC = Notification.Name.init(rawValue: "ShowChatMessageVC")
        /// 显示视频后的对应页面
        public static let ShowVideoEndVC = Notification.Name.init(rawValue: "ShowVideoEndVC")
        /// 隐藏呼叫或视频页面
        public static let DismissCallVideoVC = Notification.Name.init(rawValue: "DismissCallVideoVC")
    }
}
extension NotificationCenter {
    public static func post(name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}
