
import UIKit
import Moya.Swift
import BFKit.Swift

/// 基础请求接口
public enum ZNetworkTargetType {
    /// 请求接口
    case get(ZNetworkAction, [String: Any]?)
    /// 请求接口
    case post(ZNetworkAction, [String: Any]?)
    /// 上传图片
    case uploadImages(ZNetworkAction, [UIImage])
    /// 上传文件
    case uploadFiles(ZNetworkAction, [Data], zFileType)
}
/// 基础请求实现
extension ZNetworkTargetType: TargetType {
    
    public var baseURL: URL {
        return URL.init(string: ZKey.service.api)!
    }
    public var path: String {
        switch self {
        case .get(let val, _): return (val.rawValue)
        case .post(let val, _): return (val.rawValue)
        case .uploadImages(let val, _), .uploadFiles(let val, _, _): return (val.rawValue)
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
                if let data = image.jpegData(compressionQuality: ZKey.number.pngToJpegCompress) {
                    let provider = MultipartFormData.FormDataProvider.data(data)
                    let fileName = ZKit.getRandomId()
                    let format = MultipartFormData.init(provider: provider, name: "file", fileName: "\(fileName).jpeg", mimeType: "image/jpeg")
                    datas.append(format)
                }
            }
            return .uploadMultipart(datas)
        case .uploadFiles(_, let files, let type):
            var datas = [MultipartFormData]()
            files.forEach { (data) in
                let provider = MultipartFormData.FormDataProvider.data(data)
                let fileName = ZKit.getRandomId()
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
            guard let parameter = self.parameters else {
                return .requestParameters(parameters: ["key" : "value"], encoding: URLEncoding.queryString)
            }
            return .requestParameters(parameters: parameter, encoding: URLEncoding.queryString)
        }
    }
    public var headers: [String: String]? {
        return ZRequestHeaders()
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
