
import UIKit

private struct ZRouterRoot {
    public static func currentTopViewController() -> UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            return currentTopViewController(rootViewController: rootViewController)
        }
        return nil
    }
    private static func currentTopViewController(rootViewController: UIViewController) -> UIViewController {
        if (rootViewController.isKind(of: UITabBarController.self)) {
            let tabBarController = rootViewController as! UITabBarController
            return currentTopViewController(rootViewController: tabBarController.selectedViewController!)
        }
        if (rootViewController.isKind(of: UINavigationController.self)) {
            let navigationController = rootViewController as! UINavigationController
            return currentTopViewController(rootViewController: navigationController.visibleViewController!)
        }
        if ((rootViewController.presentedViewController) != nil) {
            return currentTopViewController(rootViewController: rootViewController.presentedViewController!)
        }
        return rootViewController
    }
}
public enum ZRoutableVC: ZRoutable {
    
    case create(_ class: AnyClass, _ params: [String: Any]? = nil)
    
    public var any: AnyClass {
        switch self {
        case .create(let vc, _): return vc.self
        }
    }
    public var params: [String: Any]? {
        switch self {
        case .create(_, let param): return param
        }
    }
}
public protocol ZRoutable {
    var any: AnyClass { get }
    var params: [String: Any]? { get }
}
public protocol ZRoutableBase {
    static func initWithParams(params: [String: Any]?) -> UIViewController
}
public struct ZRouterKit {
    public static func push(path: ZRoutable, animated: Bool = true, fromVC: UIViewController? = nil) {
        if let cls = path.any as? ZRoutableBase.Type {
            let toVC = cls.initWithParams(params: path.params)
            toVC.hidesBottomBarWhenPushed = true
            if fromVC != nil {
                fromVC?.navigationController?.pushViewController(toVC, animated: animated)
                return
            }
            let topViewController = ZRouterRoot.currentTopViewController()
            topViewController?.navigationController?.pushViewController(toVC, animated: animated)
        }
    }
    public static func push(animated: Bool = true, fromVC: UIViewController? = nil, toVC: UIViewController) {
        toVC.hidesBottomBarWhenPushed = true
        if fromVC != nil {
            fromVC?.navigationController?.pushViewController(toVC, animated: animated)
            return
        }
        let topViewController = ZRouterRoot.currentTopViewController()
        topViewController?.navigationController?.pushViewController(toVC, animated: animated)
    }
    public static func pop(fromVC: UIViewController, toVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        if let vc = toVC {
            fromVC.navigationController?.popToViewController(vc, animated: animated)
        } else {
            fromVC.navigationController?.popViewController(animated: animated)
        }
        CATransaction.commit()
    }
    public static func popToRoot(fromVC: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        fromVC?.navigationController?.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    public static func present(path: ZRoutable, animated: Bool = true, fromVC: UIViewController? = nil, completion: (()->Void)? = nil) {
        if let cls = path.any as? ZRoutableBase.Type {
            let toVC = cls.initWithParams(params: path.params)
            if fromVC != nil {
                fromVC?.present(toVC, animated: animated , completion: completion)
                return
            }
            if let vc = ZCurrentVC.shared.currentPresentVC {
                vc.present(toVC, animated: animated , completion: completion)
                return
            }
            if let vc = ZCurrentVC.shared.currentVC {
                vc.present(toVC, animated: animated , completion: completion)
                return
            }
            let topViewController = ZRouterRoot.currentTopViewController()
            topViewController?.present(toVC, animated: animated , completion: completion)
        }
    }
    public static func present(animated: Bool = true, fromVC: UIViewController? = nil, toVC: UIViewController, completion: (()->Void)? = nil) {
        if fromVC != nil {
            fromVC?.present(toVC, animated: animated , completion: completion)
            return
        }
        if let vc = ZCurrentVC.shared.currentPresentVC {
            vc.present(toVC, animated: animated , completion: completion)
            return
        }
        if let vc = ZCurrentVC.shared.currentVC {
            vc.present(toVC, animated: animated , completion: completion)
            return
        }
        let topViewController = ZRouterRoot.currentTopViewController()
        topViewController?.present(toVC, animated: animated , completion: completion)
    }
    public static func dismiss(fromVC: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        fromVC.dismiss(animated: animated, completion: completion)
    }
}
