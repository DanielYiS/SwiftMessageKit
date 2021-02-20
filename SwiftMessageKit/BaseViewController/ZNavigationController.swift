
import UIKit
import SwiftBasicKit

public class ZNavigationController: UINavigationController {
    
    public var backgroundImage: UIImage? {
        didSet {
            self.navigationBar.setBackgroundImage(backgroundImage, for: UIBarMetrics.default)
        }
    }
    public var shadowImage: UIImage? {
        didSet {
            self.navigationBar.shadowImage = shadowImage
        }
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    public override var shouldAutorotate: Bool {
        return self.viewControllers.last?.shouldAutorotate ?? false
    }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations ?? UIInterfaceOrientationMask.portrait
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation ?? UIInterfaceOrientation.portrait
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.innerInitView()
    }
    public override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        self.innerInitView()
    }
    public required convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.delegate = self
        self.navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func innerInitView() {
        
        self.navigationBar.isTranslucent = true
        self.modalPresentationStyle = .fullScreen
        
        self.shadowImage = UIImage.init(color: ZColor.shared.NavBarLineColor)?.withAlpha(0)
        self.backgroundImage = UIImage.init(color: ZColor.shared.NavBarTintColor)?.withAlpha(0)
    }
}
/// MARK: - UINavigationControllerDelegate
extension ZNavigationController: UINavigationControllerDelegate  {
    /// 自定义push pop动画效果
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    public override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
}
/// MARK: - UIGestureRecognizerDelegate
extension ZNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
        }
        return true
    }
}
