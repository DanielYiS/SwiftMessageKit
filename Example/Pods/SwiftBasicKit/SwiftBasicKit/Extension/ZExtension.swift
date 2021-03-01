
import UIKit
import BFKit.Swift
import SnapKit.Swift
import Kingfisher.Swift

extension Notification {
    public struct Names {
        /// 登录状态改变
        public static let LoginExpired = Notification.Name.init(rawValue: "LoginExpired")
        /// 网络请求开始
        public static let ApiRequestStart = Notification.Name.init(rawValue: "ApiRequestStart")
        /// 网络请求错误
        public static let ApiRequestError = Notification.Name.init(rawValue: "ApiRequestError")
        /// 消息未读数量
        public static let MessageUnReadCount = Notification.Name.init(rawValue: "MessageUnReadCount")
        /// 接收到聊天消息
        public static let ReceivedNewMessage = Notification.Name.init(rawValue: "ReceivedNewMessage")
        /// 接收到事件消息
        public static let ReceivedEventMessage = Notification.Name.init(rawValue: "ReceivedEventMessage")
        /// 显示用户详情页面
        public static let ShowUserDetailVC = Notification.Name.init(rawValue: "ShowUserDetailVC")
        /// 显示充值提醒页面
        public static let ShowRechargeReminderVC = Notification.Name.init(rawValue: "ShowRechargeReminderVC")
        /// 声网上传一张图片
        public static let AgoraUploadImage = Notification.Name.init(rawValue: "AgoraUploadImage")
        /// 声网上传一个文件
        public static let AgoraUploadFile = Notification.Name.init(rawValue: "AgoraUploadFile")
        /// 声网发送一条消息
        public static let AgoraSendMessage = Notification.Name.init(rawValue: "AgoraSendMessage")
    }
}
extension NotificationCenter {
    public static func post(name: Notification.Name, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}
extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        
        return items
    }
    public func queryValue(for key: String) -> String? {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }
    public func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters
            .map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }
    public mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }
    public init?(string: String?, relativeTo url: URL? = nil) {
        guard let string = string else { return nil }
        self.init(string: string, relativeTo: url)
    }
}
extension UIDevice {
    /// Device Name
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("", { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        })
        switch identifier {
        case "iPod1,1": return "iPod Touch 1G"
        case "iPod2,1": return "iPod Touch 2G"
        case "iPod3,1": return "iPod Touch 3G"
        case "iPod4,1": return "iPod Touch 4G"
        case "iPod5,1": return "iPod Touch 5G"
        case "iPod7,1": return "iPod Touch 6G"
        case "iPhone1,1": return "iPhone 2G"
        case "iPhone1,2": return "iPhone 3G"
        case "iPhone2,1": return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1": return "iPhone 5"
        case "iPhone5,2": return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3": return "iPhone 5c (GSM)"
        case "iPhone5,4": return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1": return "iPhone 5s (GSM)"
        case "iPhone6,2": return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        /// "国行、日版、港行iPhone 7"
        case "iPhone9,1": return "iPhone 7"
        /// "港行、国行iPhone 7 Plus"
        case "iPhone9,2": return "iPhone 7 Plus"
        /// "美版、台版iPhone 7"
        case "iPhone9,3": return "iPhone 7"
        /// "美版、台版iPhone 7 Plus"
        case "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone10,1": return "iPhone 8"
        case "iPhone10,4": return "iPhone 8"
        case "iPhone10,2": return "iPhone 8 Plus"
        case "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3": return "iPhone X"
        case "iPhone10,6": return "iPhone X"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4", "iPhone11,6": return "iPhone XS Max"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12  Pro"
        case "iPhone13,4": return "iPhone 12  Pro Max"
        case "iPad1,1": return "iPod Touch 1G"
        case "iPad1,2": return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPod Touch 2G"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini 1G"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad6,3", "iPad6,4": return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8": return "iPad Pro 12.9"
        case "AppleTV2,1": return "Apple TV 2"
        case "AppleTV3,1", "AppleTV3,2": return "Apple TV 3"
        case "AppleTV5,3": return "Apple TV 4"
        case "i386", "x86_64": return "iPhone 11 Pro"
        default: return "iPhone"
        }
    }
}
extension UIImageView {
    
    private struct AssociatedKey {
        static var viewUrl = "viewUrl"
        static var viewActivityIndicator = "viewActivityIndicator"
    }
    public var currentUrlStr: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewUrl) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewUrl, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var aiView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewActivityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewActivityIndicator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func setImageWitUrl(_ strUrl: String, _ placeholder: UIImage?) {
        
        self.clipsToBounds = true
        self.contentMode = UIView.ContentMode.scaleAspectFill
        if strUrl.count == 0 {
            self.image = placeholder
            return
        }
        guard let url = URL.init(string: strUrl) else {
            return
        }
        self.currentUrlStr = strUrl
        if self.aiView == nil {
            let aiView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
            
            self.aiView = aiView
            self.addSubview(self.aiView!)
            self.bringSubviewToFront( self.aiView!)
            
            self.aiView?.snp.remakeConstraints { (make) in
                make.center.equalTo(self.snp.center)
                make.width.height.equalTo(30)
            }
        }
        self.aiView?.startAnimating()
        let imageResource = ImageResource.init(downloadURL: url, cacheKey: url.absoluteString.md5())
        let options = [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.25))]
        self.kf.setImage(with: imageResource, placeholder: placeholder, options: options, progressBlock: { (receivedSize, totalSize) in
            
        }, completionHandler: { [weak self] (result) in
            self?.aiView?.stopAnimating()
            self?.aiView?.removeFromSuperview()
            self?.aiView = nil
            switch result {
            case .success(let rst): self?.image = rst.image
            case .failure(_): BFLog.debug("download image error: \(self?.currentUrlStr ?? "")")
            }
        })
    }
}
extension CGFloat {
    public var scale: CGFloat {
        return self * kScreenScale
    }
}
extension Int {
    public var scale: CGFloat {
        return CGFloat(self) * kScreenScale
    }
}
extension Double {
    public var scale: CGFloat {
        return CGFloat(self) * kScreenScale
    }
}
extension String {
    public var color: UIColor {
        return UIColor.init(hex: self)
    }
    public var scale: CGFloat {
        return CGFloat(self.floatValue) * kScreenScale
    }
    public var length: Int {
        return self.count
    }
    public var integerValue: Int {
        return Int(NSString(string: self).integerValue)
    }
    public var longLongValue: Int64 {
        return Int64(NSString(string: self).longLongValue)
    }
    public var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    public func isEqual(_ value: String) -> Bool {
        return self == value
    }
    public func toRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }
    public func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: utf16),
              let to = range.upperBound.samePosition(in: utf16) else {
            return nil
        }
        let location = utf16.distance(from: utf16.startIndex, to: from)
        let length = utf16.distance(from: from, to: to)
        
        return NSRange(location: location, length: length)
    }
    public func getWidth(_ font: UIFont, height: CGFloat = 22) -> CGFloat {
        
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.width)
    }
    public func getHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.height)
    }
    public func getOneHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: " ").boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.height)
    }
}
extension CGRect {
    public var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            var newFrame = self
            newFrame.origin.x = newValue
            self = newFrame
        }
    }
    public var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            var newFrame = self
            newFrame.origin.y = newValue
            self = newFrame
        }
    }
    public var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            var newFrame = self
            newFrame.size.width = newValue
            self = newFrame
        }
    }
    public var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            var newFrame = self
            newFrame.size.height = newValue
            self = newFrame
        }
    }
    public init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.init(x: x, y: y, width: w, height: h)
    }
}
extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var newFrame = self.frame
            newFrame.origin.x = newValue
            self.frame = newFrame
        }
    }
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var newFrame = self.frame
            newFrame.origin.y = newValue
            self.frame = newFrame
        }
    }
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
    }
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
    }
    public var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    public func screenShots() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension Error {
    
    public var code: Int {
        return (self as NSError).code
    }
    public var domain: String {
        return (self as NSError).domain
    }
}
extension UIFont {
    
    public static func systemFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: (size))
    }
    public static func boldSystemFont(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: (size))
    }
}
extension UILabel {
    
    public var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.systemFont(newValue)
        }
    }
    public var boldSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.boldSystemFont(newValue)
        }
    }
}
extension UIImage {
    
    public class func withColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
    public func withAlpha(_ alpha: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContext(self.size)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx?.scaleBy(x: 1.0, y: -1.0)
        ctx?.translateBy(x: 0, y: -rect.size.height)
        ctx?.setBlendMode(CGBlendMode.multiply)
        ctx?.setAlpha(alpha)
        ctx?.draw(self.cgImage!, in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public func getJPEGData() -> Data? {
        guard let data = self.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        return data
    }
}
