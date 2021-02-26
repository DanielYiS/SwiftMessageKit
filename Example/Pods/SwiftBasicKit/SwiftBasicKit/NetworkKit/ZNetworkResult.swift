
import UIKit

/// 请求返回对象处理
public struct ZNetworkResult {
    
    public var code: Int = -1
    public var success: Bool = false
    public var body: Any?
    public var message: String = ""
    
    public static func create(data: [String: Any]?) -> ZNetworkResult {
        var result = ZNetworkResult()
        if let dic = data {
            if let ret = dic["error_code"] {
                switch ret {
                case is String: result.code = (ret as? String)?.intValue ?? -1
                default:  result.code = (ret as? Int) ?? -1
                }
            } else {
                result.code = -1
            }
            result.body = dic["data"]
            result.success = (result.code == ZNetworkCode.success)
            let message = (dic["message"] as? String) ?? ""
            result.message = message
        } else {
            result.code = -1
            result.body = nil
            result.message = L10n.errorResultData
            result.success = false
        }
        return result
    }
    public static func create(with error: Error) -> ZNetworkResult {
        var result = ZNetworkResult()
        
        result.code = -1
        result.body = nil
        result.message = error.localizedDescription
        result.success = false
        
        return result
    }
}

