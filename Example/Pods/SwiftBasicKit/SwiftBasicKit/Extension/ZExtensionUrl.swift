
import UIKit
import BFKit

extension URL {
    public static func isUsedProxy() -> Bool {
        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        guard let dic = proxy as? [String: Any] else { return false }
        BFLog.debug("proxy: \(dic)")
        if let HTTPProxy = dic["HTTPProxy"] as? String, HTTPProxy.count > 0 {
            return true
        }
        if let SCOPED = dic["__SCOPED__"] as? [String: Any] {
            var isUsed = false
            SCOPED.keys.forEach { (key) in
                if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
                    isUsed = true
                }
            }
            return isUsed
        }
        return false
    }
    public static func openURL(_ str: String) {
        guard let url = URL.init(string: str) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                BFLog.debug("open status: \(success)")
            })
        }
    }
    public static func openSetting() {
        URL.openURL(UIApplication.openSettingsURLString)
    }
    public init?(string: String?, relativeTo url: URL? = nil) {
        guard let string = string else { return nil }
        self.init(string: string, relativeTo: url)
    }
    
}
