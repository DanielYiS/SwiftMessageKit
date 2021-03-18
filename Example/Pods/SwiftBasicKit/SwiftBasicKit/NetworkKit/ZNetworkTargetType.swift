
import UIKit
import Moya.Swift
import BFKit.Swift

internal func ZRequestHeaders() -> [String: String] {
    var headFields = [String: String]()
    headFields["appid"] = ZKey.appId.serviceAppId
    headFields["version"] = kAppVersion
    headFields["Authorization"] = "Bearer " + ZKey.shared.token
    headFields["AuthorizationName"] = "iOS"
    headFields["AuthorizationPassword"] = "Live"
    headFields["Content-Type"] = "application/json"
    return headFields
}
fileprivate func ZRequestParameter(_ params: [String: Any]?) -> [String: Any]? {
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

/// 基础请求接口
public enum ZNetworkTargetType {
    /// 请求接口
    case get(String, [String: Any]?)
    /// 请求接口
    case post(String, [String: Any]?)
    /// 上传图片
    case uploadImages(String, [UIImage])
    /// 上传文件
    case uploadFiles(String, [Data], zFileType)
}
/// 基础请求实现
extension ZNetworkTargetType: TargetType {
    
    public var baseURL: URL {
        return URL.init(string: ZKey.service.api)!
    }
    public var path: String {
        switch self {
        case .get(let val, _): return (val)
        case .post(let val, _): return (val)
        case .uploadImages(let val, _), .uploadFiles(let val, _, _): return (val)
        }
    }
    public var parameters: [String: Any]? {
        switch self {
        case .get(_, let params): return ZRequestParameter(params)
        case .post(_, let params): return ZRequestParameter(params)
        default: break
        }
        return nil
    }
    public var method: Moya.Method {
        switch self {
        case .get(_, _): return .get
        default: break
        }
        return .post
    }
    public var task: Task {
        switch self {
        case .uploadImages(_, let images):
            var datas = [MultipartFormData]()
            images.forEach { (image) in
                if let data = image.jpegData(compressionQuality: 0.6) {
                    let provider = MultipartFormData.FormDataProvider.data(data)
                    let fileName = kRandomId
                    let format = MultipartFormData.init(provider: provider, name: "file", fileName: "\(fileName).jpeg", mimeType: "image/jpeg")
                    datas.append(format)
                }
            }
            return .uploadMultipart(datas)
        case .uploadFiles(_, let files, let type):
            var datas = [MultipartFormData]()
            files.forEach { (data) in
                let provider = MultipartFormData.FormDataProvider.data(data)
                let fileName = kRandomId
                var mimetype = "image/" + type.rawValue
                switch type {
                case .jpeg, .png: mimetype = "image/" + type.rawValue
                case .mp3:  mimetype = "audio/" + type.rawValue
                case .mp4, .wav:  mimetype = "video/" + type.rawValue
                }
                let format = MultipartFormData.init(provider: provider, name: "file", fileName: "\(fileName).\(type.rawValue)", mimeType: mimetype)
                datas.append(format)
            }
            return .uploadMultipart(datas)
        default:
            switch self {
            case .get(_, _):
                guard let parameter = self.parameters else {
                    return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
                }
                return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
            default: break
            }
            guard let parameter = self.parameters else {
                return .requestParameters(parameters: [:], encoding: JSONEncoding.prettyPrinted)
            }
            return .requestParameters(parameters: parameter, encoding: JSONEncoding.prettyPrinted)
        }
    }
    public var headers: [String: String]? {
        return ZRequestHeaders()
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
