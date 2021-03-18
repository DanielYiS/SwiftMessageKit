
import UIKit

/// 获取参数
public struct ZParams {

    /// 单例模式
    public static let shared = ZParams()
    /// 基础参数
    public var appParams: [String: Any] {
        var tmp = [String: Any]()
        tmp["app_id"] = ZKey.appId.serviceAppId
        tmp["version"] = kAppVersion
        tmp["device"] = ["udid": ZKey.shared.udid,
                         "name": kDeviceName,
                         "system": ["name": kSystemName, "version": kSystemVersion, "language": kCurrentLanguage, "timezone": kTimeZoneName],
                         "network": ["vpn": URL.isUsedProxy()]]
        tmp["source"] = ["media": ZKey.shared.media]
        return tmp
    }
}
