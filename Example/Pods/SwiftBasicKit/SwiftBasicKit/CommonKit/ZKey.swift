
import UIKit

/// 全局配置主键
public struct ZKey {
    
    public static var shared = ZKey.init()
    
    private var productIds: [String] = [String]()
    
    private var api = ""
    private var web = ""
    private var wss = ""
    
    /// 苹果appid - 用于跳转苹果应用
    private var appleId = ""
    /// 服务器Appid
    private var serviceAppId = ""
    /// IM消息平台
    private var messageAppId = ""
    /// 推送平台
    private var pushAppId = ""
    /// bug收集平台
    private var bugAppId = ""
    /// 统计平台
    private var countAppId = ""
    
    /// 关于我们
    public var aboutMe = ""
    /// 团队服务
    public var teamService = ""
    /// 免责申明
    public var disclaimer = ""
    /// 使用协议
    public var useAgreement = ""
    /// 支付协议
    public var payAgreement = ""
}
extension ZKey {
    /// 时间格式化
    public static let timeFormat = TimeFormat.init()
    /// 时间格式化
    public struct TimeFormat {
        /// MM/dd/yyyy HH:mm
        public let yyyyMMddHHmm: String = "MM/dd/yyyy HH:mm"
        /// MM/dd/yyyy
        public let yyyyMMdd: String = "MM/dd/yyyy"
        /// MM/dd
        public let MMdd: String = "MM/dd"
        /// HH:mm:ss
        public let HHmmss: String = "HH:mm:ss"
        /// HH:mm
        public let HHmm: String = "HH:mm"
    }
}
extension ZKey {
    /// 第三方产品ID
    public static let appId = AppId.init()
    /// 第三方产品ID
    public struct AppId {
        public let appleId      = ZKey.shared.appleId
        public let serviceAppId = ZKey.shared.serviceAppId
        public let messageAppId = ZKey.shared.messageAppId
        public let pushAppId    = ZKey.shared.pushAppId
        public let bugAppId     = ZKey.shared.bugAppId
        public let countAppId   = ZKey.shared.countAppId
    }
    /// 配置AppId
    /// - parameter appleId: 苹果应用ID
    /// - parameter serviceAppId :服务器应用ID
    /// - parameter messageAppId: 聊天消息应用ID
    /// - parameter pushAppId: 推送平台应用ID
    /// - parameter bugAppId: Bug收集平台应用ID
    /// - parameter countAppId: 统计平台应用ID
    /// - returns: null
    /// - throws: null
    public func configAppId(appleId: String, serviceAppId: String, messageAppId: String, pushAppId: String, bugAppId: String, countAppId: String) {
        ZKey.shared.appleId = appleId
        ZKey.shared.serviceAppId = serviceAppId
        ZKey.shared.messageAppId = messageAppId
        ZKey.shared.pushAppId = pushAppId
        ZKey.shared.bugAppId = bugAppId
        ZKey.shared.countAppId = countAppId
    }
}
extension ZKey {
    /// 服务器地址
    public static let service = Service.init()
    /// 服务器地址
    public struct Service {
        public let api = ZKey.shared.api
        public let web = ZKey.shared.web
        public let wss = ZKey.shared.wss
    }
    /// 配置服务器地址
    /// - parameter api: 接口跟地址
    /// - parameter web: 网页跟地址
    /// - parameter wss: IM连接地址
    public func configService(api: String, web: String, wss: String) {
        ZKey.shared.api = api
        ZKey.shared.web = web
        ZKey.shared.wss = wss
    }
}
extension ZKey {
    public static let applePay = ApplePay.init()
    public struct ApplePay {
        public func isExistProductId(id: String) -> Bool {
            return ZKey.shared.productIds.contains(id)
        }
    }
    public func configProductIds(ids: [String]) {
        ZKey.shared.productIds.removeAll()
        ZKey.shared.productIds.append(contentsOf: ids)
    }
}
