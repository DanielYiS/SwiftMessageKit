
import UIKit
import BFKit

extension URL {
    public static func isUsedProxy() -> Bool {
        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        guard let dict = proxy as? [String: Any] else { return false }
        let isUsed = dict.isEmpty
        guard let HTTPProxy = dict["HTTPProxy"] as? String else { return false }
        if HTTPProxy.count > 0 { return true }
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
