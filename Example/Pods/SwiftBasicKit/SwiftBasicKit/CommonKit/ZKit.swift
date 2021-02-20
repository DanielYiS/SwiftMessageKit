import UIKit
import Foundation

/// 全局常量
public struct ZKit {
    
    /// CellId
    public static let kCellId = "kCellId"
    /// CellHeader
    public static let kCellHeaderId = "kCellHeaderId"
    /// CellFooter
    public static let kCellFooterId = "kCellFooterId"
    
    /// 屏幕宽度
    public static let kScreenWidth: CGFloat = UIScreen.main.bounds.size.width
    /// 屏幕高度
    public static let kScreenHeight: CGFloat = UIScreen.main.bounds.size.height
    /// 设计比例
    public static let kScreenScale: CGFloat = ZKit.kScreenWidth/375
    
    /// 状态栏高度 44 || 20
    public static let kStatusHeight: CGFloat = (ZKit.kIsIPhoneX) ? 44 : 20
    /// 导航栏宽度 屏幕宽度
    public static let kNavigationWidth: CGFloat = kScreenWidth
    /// 导航栏高度 44
    public static let kNavigationHeight: CGFloat = 44
    /// 顶部区域高度
    public static let kTopNavHeight: CGFloat = ZKit.kStatusHeight + ZKit.kNavigationHeight
    /// TAB栏高度 83 || 49
    public static let kTabbarHeight: CGFloat = (ZKit.kIsIPhoneX) ? 83 : 49
    /// iPhoneX 底部多余高度 34
    public static let kTabbarHeightX: CGFloat = 34
    /// 默认控件在页面Y坐标 - 导航栏下面
    public static func kFullScreenY() -> CGFloat {
        if #available(iOS 11.0, *) {
            return ZKit.kTopNavHeight
        } else {
            return ZKit.kTopNavHeight
        }
    }
    /// 默认视图在页面显示高度 - 除去导航栏
    public static func kFullScreenHeight() -> CGFloat {
        return ZKit.kScreenHeight - ZKit.kFullScreenY()
    }
    /// 是否IPad
    public static let kIsIPadDevice: Bool = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
    /// 是否IPhone
    public static let kIsIPhoneDevice = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)
    /// 是否CarPlay
    public static let kIsCarPlayDevice = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.carPlay)
    
    /// 是否IPhone4
    public static let kIsIPhone4 = (ZKit.kScreenWidth == 320 && ZKit.kScreenHeight == 480)
    /// 是否IPhone5
    public static let kIsIPhone5 = (ZKit.kScreenWidth == 320 && ZKit.kScreenHeight == 568)
    /// 是否iPhone678
    public static let kIsIPhone6 = (ZKit.kScreenWidth == 375 && ZKit.kScreenHeight == 667)
    /// 是否iPhone678P
    public static let kIsIPhone6P = (ZKit.kScreenWidth == 414 && ZKit.kScreenHeight == 736)
    /// 是否IPhoneX XS XR Max
    public static let kIsIPhoneX = ((ZKit.kScreenWidth == 375 && ZKit.kScreenHeight == 812) || //x -> 11
                                        (ZKit.kScreenWidth == 390 && ZKit.kScreenHeight == 844) || //12
                                        (ZKit.kScreenWidth == 414 && ZKit.kScreenHeight == 896) || //x max -> 11 max
                                        (ZKit.kScreenWidth == 428 && ZKit.kScreenHeight == 926)) //12 max
    
    /// 获取数值比例
    public static func kFuncScale(_ value: CGFloat) -> CGFloat {
        return value * ZKit.kScreenScale
    }
    /// 系统语言
    public static func kFuncCurrentLanguage() -> String {
        let preferredLang = Bundle.main.preferredLocalizations.first ?? ""
        switch preferredLang {
        case "en-US", "en-CN":
            return "en"//英文
        case "zh-Hans-US","zh-Hans-CN","zh-Hant-CN","zh-TW","zh-HK","zh-Hans":
            return "zh"//中文
        default: break
        }
        return preferredLang
    }
    /// 生成随机32位加密字符串
    public static func getRandomId() -> String {
        return "\(Date.init().timeIntervalSince1970)\(ZSettingKit.shared.userId)\(arc4random())".md5()
    }
    
}
