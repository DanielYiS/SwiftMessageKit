
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
    /// 自定义限制
    public static let number = Number.init()
    /// 自定义限制
    public struct Number {
        /// 键盘最小高度
        public let keyboardHeight: CGFloat = 180
        /// 动画时间 0.25
        public let animateTime: TimeInterval = 0.25
        /// 提示框等待时长
        public let toastWaitTime: TimeInterval = 5
        /// 消息重连间隔 10
        public let messageReconnectTime: TimeInterval = 10
        /// 广告切换间隔
        public let bannerSwitchTime: TimeInterval = 5.0
        /// PNG->JPEG压缩值
        public let pngToJpegCompress: CGFloat = 0.6
        
        /// 分页默认数量 10
        public let pageCount: Int = 10
        /// 显示最大数量 999
        public let maxCount: Int = 999
        
        /// 超过多少秒评价
        public let evaluationTime: Int = 60
        
        /// 昵称最小数量 3
        public let nickNameMinCount: Int = 3
        /// 昵称最大数量 20
        public let nickNameMaxCount: Int = 20
        
        /// 邮箱长度最小值 6
        public let emailMinCount: Int = 6
        /// 邮箱长度最大值 50
        public let emailMaxCount: Int = 50
        
        /// 密码长度最小值 6
        public let passwordMinCount: Int = 6
        /// 密码长度最大值 20
        public let passwordMaxCount: Int = 20
        
        /// 关于我最大数量 140
        public let aboutMeMaxCount: Int = 140
        /// 消息内容长度限制 140
        public let messageMaxCount: Int = 140
        /// 举报内容长度限制 10
        public let reportMinCount: Int = 10
        /// 举报内容长度限制 140
        public let reportMaxCount: Int = 140
        /// 意见反馈长度限制 10
        public let feedBackMinCount: Int = 10
        /// 意见反馈长度限制 140
        public let feedBackMaxCount: Int = 140
        
        /// 年龄长度最大值 3
        public let ageMaxCount: Int = 3
        /// 最大年龄 80
        static let ageMax: Int = 80
        /// 最小年龄 18
        static let ageMin: Int = 18
        /// 默认年龄 25
        static let ageDefault: Int = 25
        
        /// 最大照片数量 9
        static let photoMaxCount: Int = 9
        
        /// Tag最大选中数量 10
        static let tagMaxCount: Int = 10
        
        /// 最小距离 5
        static let distanceMin: Int = 5
        /// 最小距离 200
        static let distanceMax: Int = 200
    }
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
    /// 苹果内购
    public static let applePay = ApplePay.init()
    /// 苹果内购
    public struct ApplePay {
        /// 检查是否存在内购项
        public func checkExistProductId(id: String) -> Bool {
            return ZKey.shared.productIds.contains(id)
        }
    }
    /// 配置内购ID集合
    /// - parameter ids: 内购ID集合
    public func configProductIds(ids: [String]) {
        ZKey.shared.productIds.removeAll()
        ZKey.shared.productIds.append(contentsOf: ids)
    }
}
extension ZKey {
    /// 手机系统名称
    public static let SystemName: String = UIDevice.current.systemName
    /// 手机系统版本
    public static let SystemVersion: Float = UIDevice.current.systemVersion.floatValue
    /// 应用版本号
    public static let AppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    /// 应用名称
    public static let AppName: String = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
    /// BundleIdentifier
    public static let BundleIdentifier: String = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? ""
    /// 设备名称
    public static let DeviceName: String = UIDevice.current.modelName
    
    /// 应用地址
    public static let AppUrl: String = "itms-apps://itunes.apple.com/cn/app/id\(ZKey.appId.appleId)"
    /// 评分地址
    public static let AppRateUrl: String = "itms-apps://itunes.apple.com/app/id\(ZKey.appId.appleId)?action=write-review"
    
    /// 拨打电话
    public static let TelPhone: String = "telprompt://"
}
