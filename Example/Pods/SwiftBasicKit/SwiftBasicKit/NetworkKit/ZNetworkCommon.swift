import UIKit
import BFKit.Swift
import HandyJSON.Swift
import CryptoSwift.Swift

public typealias ZResponseBlock = ((_ result: ZNetworkResult) -> (Void))

/// 配置公共Header参数
func ZRequestHeaders() -> [String: String] {
    var headerfields = [String: String]()
    headerfields["appid"] = ZKey.appId.appleId
    headerfields["appversion"] = ZKey.AppVersion
    headerfields["Authorization"] = "Bearer " + ZSettingKit.shared.token
    headerfields["AuthorizationName"] = ZNetworkKit.authorizationName
    headerfields["AuthorizationPassword"] = ZNetworkKit.authorizationPassword
    headerfields["Content-Type"] = "application/json"
    return headerfields
}
/// 配置公共请求参数
func ZRequestParameter(_ params: [String: Any]?) -> [String: Any]? {
    guard var param = params else {
        return (params)
    }
    param["timestamp"] = Int32(Date.init().timeIntervalSince1970)
    do {
        let sign = try param.json()
        param["sign"] = sign.md5().lowercased()
    } catch  {
        BFLog.debug("params to json error: \(error.localizedDescription)")
    }
    return param
}
