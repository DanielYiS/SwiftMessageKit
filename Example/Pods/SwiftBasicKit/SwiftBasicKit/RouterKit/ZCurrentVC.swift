import UIKit

/// 当前VC管理
public struct ZCurrentVC {
    
    public static var shared = ZCurrentVC.init()
    
    /// 当前可见VC
    public weak var currentVC: UIViewController?
    /// 当前推出VC
    public weak var currentPresentVC: UIViewController?
    /// 当前导航
    public weak var rootVC: UINavigationController?
}
