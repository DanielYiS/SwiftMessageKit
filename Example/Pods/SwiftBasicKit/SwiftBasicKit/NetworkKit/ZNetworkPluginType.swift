import UIKit
import Foundation
import Moya.Swift
import BFKit.Swift
import Result.Swift

class ZNetworkPluginType: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    func willSend(_ request: RequestType, target: TargetType) {
        if target.path == (ZNetworkAction.upgrade.rawValue) { return }
        NotificationCenter.post(name: Notification.Names.ApiRequestStart, object: target.path)
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
        if target.path == (ZNetworkAction.upgrade.rawValue) { return }
        switch result {
        case .failure(let error):
            NotificationCenter.post(name: Notification.Names.ApiRequestError, object: error.localizedDescription)
        default: break
        }
    }
}
