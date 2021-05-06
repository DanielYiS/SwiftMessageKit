import UIKit
import Foundation
import Moya.Swift
import BFKit.Swift
import Result.Swift

class ZNetworkPluginType: PluginType {
    
    var isShowHud: Bool = false
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    func willSend(_ request: RequestType, target: TargetType) {
        NotificationCenter.post(name: Notification.Name.init(rawValue: "ApiRequestStart"), object: target.path)
        if self.isShowHud {
            if let vc = ZCurrentVC.shared.currentPresentVC {
                ZProgressHUD.show(vc: vc)
                return
            }
            if let vc = ZCurrentVC.shared.currentVC {
                ZProgressHUD.show(vc: vc)
                return
            }
            ZProgressHUD.show(vc: nil)
        }
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if self.isShowHud { ZProgressHUD.dismiss() }
        switch result {
        case .success(let data):
            NotificationCenter.post(name: Notification.Name.init(rawValue: "ApiRequestSuccess"), object: data)
        case .failure(let error):
            NotificationCenter.post(name: Notification.Name.init(rawValue: "ApiRequestError"), object: error.localizedDescription)
        default: break
        }
    }
}
