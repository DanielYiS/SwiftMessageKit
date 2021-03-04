import UIKit
import Foundation

/// CellId
public let kCellId = "kCellId"
/// CellHeader
public let kCellHeaderId = "kCellHeaderId"
/// CellFooter
public let kCellFooterId = "kCellFooterId"

/// 每页显示数量
public let kPageCount: Int = 10

/// 屏幕宽度
public let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
/// 屏幕高度
public let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height
/// 设计和屏幕百分比
public let kScreenScale: CGFloat = kScreenWidth/375

/// 状态栏高度 44 || 20
public let kStatusHeight: CGFloat = (kIsIPhoneX) ? 44 : 20
/// 导航栏宽度 屏幕宽度
public let kNavigationWidth: CGFloat = kScreenWidth
/// 导航栏高度 44
public let kNavigationHeight: CGFloat = 44
/// 顶部区域高度
public let kTopNavHeight: CGFloat = kStatusHeight + kNavigationHeight
/// TAB栏高度 83 || 49
public let kTabbarHeight: CGFloat = (kIsIPhoneX) ? 83 : 49
/// iPhoneX 底部多余高度 34
public let kTabbarHeightX: CGFloat = 34
/// 包含导航栏内容高度
public let kScreenMainHeight: CGFloat = kScreenHeight - kTopNavHeight

/// 是否IPad
public let kIsIPadDevice: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
/// 是否IPhone
public let kIsIPhoneDevice: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
/// 是否CarPlay
public let kIsCarPlayDevice: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.carPlay)

/// 是否IPhone4
public let kIsIPhone4   = (kScreenWidth == 320 && kScreenHeight == 480)
/// 是否IPhone5
public let kIsIPhone5   = (kScreenWidth == 320 && kScreenHeight == 568)
/// 是否iPhone678
public let kIsIPhone    = (kScreenWidth == 375 && kScreenHeight == 667)
/// 是否iPhone678P
public let kIsIPhoneP   = (kScreenWidth == 414 && kScreenHeight == 736)
/// 是否IPhoneX XS XR Max
public let kIsIPhoneX   = (!kIsIPadDevice && kScreenHeight > 736)

/// 系统语言
public let kCurrentLanguage: String = Bundle.main.preferredLocalizations.first ?? ""
/// 生成随机32位加密字符串
public var kRandomId: String { return "\(Date.init().timeIntervalSince1970)\(ZSettingKit.shared.userId)\(arc4random())".md5() }
/// 手机系统名称
public let kSystemName: String = UIDevice.current.systemName
/// 手机系统版本
public let kSystemVersion: String = UIDevice.current.systemVersion
/// 应用版本号
public let kAppVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
/// 应用名称
public let kAppName: String = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
/// BundleIdentifier
public let kBundleIdentifier: String = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? ""
/// 设备名称
public let kDeviceName: String = UIDevice.current.modelName

/// 应用地址
public let kAppUrl: String = "itms-apps://itunes.apple.com/cn/app/id\(ZKey.appId.appleId)"
/// 评分地址
public let kAppRateUrl: String = "itms-apps://itunes.apple.com/app/id\(ZKey.appId.appleId)?action=write-review"

/// 拨打电话
public let kTelPhone: String = "telprompt://"
