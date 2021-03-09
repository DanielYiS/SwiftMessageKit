
import UIKit
import BFKit

open class ZBaseViewController: UIViewController {
    
    /// 1 push 2 present
    open var showType: Int = 1
    open var page: Int = 1
    open var isCurrentShowVC: Bool = false
    open var isNavigationHidden: Bool = false
    open var isNavigationAlpha: CGFloat = 1
    open var imageBack: UIImage? = UIImage.init(named: "btn_back")
    open var keyboardHeight: CGFloat = 0
    
    open override var shouldAutorotate: Bool {
        return false
    }
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    public required convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.edgesForExtendedLayout = UIRectEdge.top
            self.viewRespectsSystemMinimumLayoutMargins = false
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.extendedLayoutIncludesOpaqueBars = false
        self.view.isUserInteractionEnabled = true
        self.view.backgroundColor = ZColor.shared.BackgroundColor
        let vcCount = self.navigationController?.viewControllers.count ?? 0
        if vcCount > 1 {
            self.setNavBarLeftButton()
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isCurrentShowVC = true
        switch self.showType {
        case 2: ZCurrentVC.shared.currentPresentVC = self
        default: ZCurrentVC.shared.currentVC = self
        }
        (self.navigationController as? ZNavigationController)?.shadowImage = UIImage.init(color: ZColor.shared.NavBarLineColor)?.withAlpha(self.isNavigationAlpha)
        (self.navigationController as? ZNavigationController)?.backgroundImage = UIImage.init(color:ZColor.shared.NavBarTintColor)?.withAlpha(self.isNavigationAlpha)
        self.navigationController?.setNavigationBarHidden(self.isNavigationHidden, animated: animated)
        BFLog.debug("viewWillAppear \(self.classForCoder)")
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isCurrentShowVC = false
        switch self.showType {
        case 2: ZCurrentVC.shared.currentPresentVC = nil
        default: break
        }
        BFLog.debug("viewWillDisappear \(self.classForCoder)")
    }
    open func keyboardFrameChange(_ height: CGFloat) {
        BFLog.debug("keyboardFrameChange: \(height)")
        self.keyboardHeight = height
    }
    public final func setNavBarLeftButton() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = nil
        
        let item = UIButton.init(type: UIButton.ButtonType.custom)
        
        item.tag = 10
        item.isUserInteractionEnabled = true
        item.setImage(self.imageBack, for: UIControl.State.normal)
        item.setImage(self.imageBack, for: UIControl.State.highlighted)
        item.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15)
        item.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        item.addTarget(self, action: #selector(self.btnNavBarLeftButtonEvent), for: UIControl.Event.touchUpInside)
        item.frame = CGRect.init(x: 0, y: 0, width: 50, height: 45)
        
        let btnBackItem = UIBarButtonItem.init(customView: item)
        
        self.navigationItem.leftBarButtonItem = btnBackItem
    }
    @objc open func btnNavBarLeftButtonEvent() {
        let vcCount: Int = self.navigationController?.viewControllers.count ?? 0
        if vcCount <= 1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            ZRouterKit.pop(fromVC: self)
        }
    }
    public final func setNavBarRightButton(text: String,
                                           color: UIColor? = ZColor.shared.NavBarButtonColor,
                                           highlightedColor: UIColor? = ZColor.shared.NavBarButtonColor) {
        self.navigationItem.rightBarButtonItem = nil
        
        let item = UIButton.init(type: UIButton.ButtonType.custom)
        
        item.tag = 20
        item.isUserInteractionEnabled = true
        item.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        item.titleLabel?.adjustsFontSizeToFitWidth = true
        item.setTitle(text, for: UIControl.State.normal)
        item.setTitle(text, for: UIControl.State.highlighted)
        item.setTitleColor(color, for: UIControl.State.normal)
        item.setTitleColor(highlightedColor, for: UIControl.State.highlighted)
        item.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        item.addTarget(self, action: #selector(self.btnNavBarRightButtonEvent), for: UIControl.Event.touchUpInside)
        item.frame = CGRect.init(x: 0, y: 0, width: 55, height: 45)
        
        let btnRightItem = UIBarButtonItem.init(customView: item)
        
        self.navigationItem.rightBarButtonItem = btnRightItem
    }
    public final func setNavBarRightButton(image: UIImage?) {
        self.navigationItem.rightBarButtonItem = nil
        
        let item = UIButton.init(type: UIButton.ButtonType.custom)
        
        item.tag = 20
        item.isUserInteractionEnabled = true
        item.setImage(image, for: UIControl.State.normal)
        item.setImage(image, for: UIControl.State.highlighted)
        item.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
        item.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        item.addTarget(self, action: #selector(self.btnNavBarRightButtonEvent), for: UIControl.Event.touchUpInside)
        item.frame = CGRect.init(x: 0, y: 0, width: 50, height: 45)
        
        let btnRightItem = UIBarButtonItem.init(customView: item)
        
        self.navigationItem.rightBarButtonItem = btnRightItem
    }
    @objc open func btnNavBarRightButtonEvent() {
        
    }
    @objc open func setReceivedNewMessage(_ sender: Notification) {
        BFLog.info("setReceivedNewMessage: \( sender.object ?? "")")
    }
}
extension ZBaseViewController {
    
    public final func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    public final func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc private func keyboardWillShow(_ sender: Notification) {
        let height = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height ?? 0
        
        self.keyboardFrameChange(height)
    }
    @objc private func keyboardWillHide(_ sender: Notification) {
        self.keyboardFrameChange(0)
    }
}
extension ZBaseViewController {
    public final func registerReceivedNewMessageNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setReceivedNewMessage(_:)), name: Notification.Names.ReceivedNewMessage, object: nil)
    }
    public  final func removeReceivedNewMessageNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedNewMessage, object: nil)
    }
    public final func postReceivedNewMessageNotification() {
        NotificationCenter.default.post(name: Notification.Names.ReceivedNewMessage, object: nil)
    }
}
