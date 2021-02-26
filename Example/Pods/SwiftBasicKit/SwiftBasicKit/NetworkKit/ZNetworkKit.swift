
import UIKit
import Moya.Swift
import CryptoSwift
import BFKit.Swift
import Result.Swift
import Alamofire.Swift

/// 网络请求库
public struct ZNetworkKit {
    
    static let authorizationName = "iOS"
    static let authorizationPassword = "Live"
    
    public static func shared() -> ZNetworkKit {
        return ZNetworkKit()
    }
    /// 网络请求对象
    private func defaultAlamofire() -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.httpAdditionalHeaders = ZRequestHeaders()
        
        let session = Alamofire.Session.init(configuration: configuration)
        return session
    }
    /// NetworkActivityPlugin插件用来监听网络请求
    private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
        switch(changeType){
        case .began:
            BFLog.debug("start network: \(targetType.path)")
        case .ended:
            BFLog.debug("end network: \(targetType.path)")
        }
    }
    /// PluginType插件用来监听网络请求过程
    private let typePlugin = ZNetworkPluginType.init()
    
    /// 开始请求的方法
    /// - parameter target 接口名称
    /// - parameter responseBlock 请求回调函数
    /// - throws: 异常描述
    /// - returns: 返回值描述
    @discardableResult
    public func startRequest(_ target: ZNetworkTargetType, responseBlock: @escaping ZResponseBlock) -> Cancellable {
        let headers = target.headers ?? [:]
        let parameters = target.parameters ?? [:]
        let path = target.path
        let provider = MoyaProvider<ZNetworkTargetType>.init(session: self.defaultAlamofire(), plugins: [self.networkPlugin, self.typePlugin], trackInflights: false)
        let task = provider.request(target, progress: nil, completion: { (result) in
            switch result {
            case .success(let response):
                do {
                    guard let dic = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any] else {
                        BFLog.debug("\n path: \(path) \n headers: \(headers) \n params: \(parameters) \n data: [not data]")
                        responseBlock(ZNetworkResult.create(data: nil))
                        return
                    }
                    BFLog.debug("\n path: \(path) \n headers: \(headers) \n params: \(parameters) \n data: \(dic)")
                    let response = ZNetworkResult.create(data: dic)
                    if response.code == ZNetworkCode.unAuthorized {
                        NotificationCenter.post(name: Notification.Names.LoginExpired)
                    }
                    responseBlock(response)
                } catch {
                    BFLog.debug("\n path: \(path) \n headers: \(headers) \n params: \(parameters) \n  error: \(error.localizedDescription)")
                    responseBlock(ZNetworkResult.create(with: error))
                }
            case .failure(let error):
                BFLog.debug("\n path: \(path) \n headers: \(headers) \n params: \(parameters) \n  error: \(error.localizedDescription)")
                responseBlock(ZNetworkResult.create(with: error))
            }
        })
        return task
    }
}
