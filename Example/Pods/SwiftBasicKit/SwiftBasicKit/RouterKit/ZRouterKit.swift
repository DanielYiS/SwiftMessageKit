
import UIKit

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
    public static func push(path: ZRoutable, fromVC: UIViewController? = nil, animated: Bool = true) {
        if let cls = path.any as? ZRoutableBase.Type {
            let toVC = cls.initWithParams(params: path.params)
            toVC.hidesBottomBarWhenPushed = true
            if fromVC != nil {
                fromVC?.navigationController?.pushViewController(toVC, animated: animated)
                return
            }
            ZCurrentVC.shared.currentVC?.navigationController?.pushViewController(toVC, animated: animated)
        }
    }
    public static func push(toVC: UIViewController, fromVC: UIViewController? = nil, animated: Bool = true) {
        toVC.hidesBottomBarWhenPushed = true
        if fromVC != nil {
            fromVC?.navigationController?.pushViewController(toVC, animated: animated)
            return
        }
        ZCurrentVC.shared.currentVC?.navigationController?.pushViewController(toVC, animated: animated)
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
            ZCurrentVC.shared.rootVC?.present(toVC, animated: animated , completion: completion)
        }
    }
    public static func present(toVC: UIViewController, fromVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
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
        ZCurrentVC.shared.rootVC?.present(toVC, animated: animated , completion: completion)
    }
}
