
import UIKit
import BFKit

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
    public static func getCurrentVC() -> UIViewController? {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let currentVC = ZRouterKit.getCurrentVC(vc: rootVC)
        return currentVC
    }
    private static func getCurrentVC(vc: UIViewController?) -> UIViewController? {
        var currentVC: UIViewController? = vc
        if let rvc = vc, rvc.isKind(of: UITabBarController.classForCoder()) {
            currentVC = ZRouterKit.getCurrentVC(vc: (rvc as? UITabBarController)?.selectedViewController)
        }
        if let rvc = vc, rvc.isKind(of: UINavigationController.classForCoder()) {
            currentVC = ZRouterKit.getCurrentVC(vc: (rvc as? UINavigationController)?.visibleViewController)
        }
        if let pvc = vc?.presentedViewController {
            currentVC = ZRouterKit.getCurrentVC(vc: pvc)
        }
        return currentVC
    }
    public static func getCurrentPushVC() -> UIViewController? {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let currentVC = ZRouterKit.getCurrentPushVC(vc: rootVC)
        return currentVC
    }
    private static func getCurrentPushVC(vc: UIViewController?) -> UIViewController? {
        var currentVC: UIViewController? = vc
        if let rvc = vc, rvc.isKind(of: UITabBarController.classForCoder()) {
            currentVC = ZRouterKit.getCurrentPushVC(vc: (rvc as? UITabBarController)?.selectedViewController)
        }
        if let rvc = vc, rvc.isKind(of: UINavigationController.classForCoder()) {
            currentVC = ZRouterKit.getCurrentPushVC(vc: (rvc as? UINavigationController)?.visibleViewController)
        }
        return currentVC
    }
    public static func push(path: ZRoutable, fromVC: UIViewController? = nil, animated: Bool = true) {
        if let cls = path.any as? ZRoutableBase.Type {
            let toVC = cls.initWithParams(params: path.params)
            toVC.hidesBottomBarWhenPushed = true
            DispatchQueue.DispatchaSync(mainHandler: {
                if fromVC != nil {
                    fromVC?.navigationController?.pushViewController(toVC, animated: animated)
                    return
                }
                ZRouterKit.getCurrentVC()?.navigationController?.pushViewController(toVC, animated: animated)
            })
        }
    }
    public static func push(toVC: UIViewController, fromVC: UIViewController? = nil, animated: Bool = true) {
        toVC.hidesBottomBarWhenPushed = true
        DispatchQueue.DispatchaSync(mainHandler: {
            if fromVC != nil {
                fromVC?.navigationController?.pushViewController(toVC, animated: animated)
                return
            }
            ZRouterKit.getCurrentVC()?.navigationController?.pushViewController(toVC, animated: animated)
        })
    }
    public static func pop(toVC: UIViewController? = nil, fromVC: UIViewController, animated: Bool = true, completion: (()->Void)? = nil) {
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
    public static func present(path: ZRoutable, fromVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
        if let cls = path.any as? ZRoutableBase.Type {
            let toVC = cls.initWithParams(params: path.params)
            DispatchQueue.DispatchaSync(mainHandler: {
                if fromVC != nil {
                    fromVC?.present(toVC, animated: animated , completion: completion)
                    return
                }
                if let pvc = ZRouterKit.getCurrentVC()?.presentedViewController {
                    pvc.present(toVC, animated: animated , completion: completion)
                    return
                }
                ZRouterKit.getCurrentVC()?.present(toVC, animated: animated, completion: completion)
            })
        }
    }
    public static func present(toVC: UIViewController, fromVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
        DispatchQueue.DispatchaSync(mainHandler: {
            if fromVC != nil {
                fromVC?.present(toVC, animated: animated , completion: completion)
                return
            }
            if let pvc = ZRouterKit.getCurrentVC()?.presentedViewController {
                pvc.present(toVC, animated: animated , completion: completion)
                return
            }
            ZRouterKit.getCurrentVC()?.present(toVC, animated: animated, completion: completion)
        })
    }
    public static func dismiss(fromVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
        DispatchQueue.DispatchaSync(mainHandler: {
            if let _ = fromVC?.presentingViewController {
                fromVC?.presentingViewController?.dismiss(animated: animated, completion: completion)
                return
            }
            fromVC?.dismiss(animated: animated, completion: completion)
        })
    }
}
