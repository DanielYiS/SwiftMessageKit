
import UIKit
import BFKit
import SwiftBasicKit

open class ZBaseViewController: UIViewController {
    
    /// 是否在支付中
    open var isApplePaying: Bool = false
    /// 当前页面显示类型  1 push 2 present
    open var viewShowType: Int = 1
    /// 当前第几页
    open var page: Int = 1
    /// 是否显示该页面
    open var isCurrentShowVC: Bool = false
    /// 是否隐藏当前页面导航栏
    open var isHiddenNavigationBar: Bool = false
    /// 导航栏透明度
    open var isNavigationAlpha: CGFloat = 1
    /// 返回图片
    open var imageBack: UIImage? = UIImage.init(named: "btn_back")
    /// 键盘高度
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
        switch self.viewShowType {
        case 2: ZCurrentVC.shared.currentPresentVC = self
        default: ZCurrentVC.shared.currentVC = self
        }
        (self.navigationController as? ZNavigationController)?.shadowImage = UIImage.init(color: ZColor.shared.NavBarLineColor)?.withAlpha(self.isNavigationAlpha)
        (self.navigationController as? ZNavigationController)?.backgroundImage = UIImage.init(color:ZColor.shared.NavBarTintColor)?.withAlpha(self.isNavigationAlpha)
        self.navigationController?.setNavigationBarHidden(self.isHiddenNavigationBar, animated: animated)
        BFLog.debug("viewWillAppear \(self.classForCoder)")
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.isCurrentShowVC = false
        switch self.viewShowType {
        case 2: ZCurrentVC.shared.currentPresentVC = nil
        default: break
        }
        BFLog.debug("viewWillDisappear \(self.classForCoder)")
    }
    /// 监听键盘高度改变事件
    open func keyboardFrameChange(_ height: CGFloat) {
        BFLog.debug("keyboardFrameChange: \(height)")
        self.keyboardHeight = height
    }
    /// 设置导航栏左侧按钮
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
    /// 设置导航栏右侧按钮
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
    /// 设置导航栏右侧按钮
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
    /// 导航栏右侧按钮事件
    @objc open func btnNavBarRightButtonEvent() {
        
    }
    /// 接收到IM消息
    @objc open func setReceivedNewMessage(_ sender: Notification) {
        BFLog.info("setReceivedNewMessage: \( sender.object ?? "")")
    }
}
extension ZBaseViewController {
    
    /// 注册键盘显示和隐藏的通知
    public final func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// 移除键盘显示和隐藏的通知
    public final func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// 执行键盘显示和隐藏的通知
    @objc private func keyboardWillShow(_ sender: Notification) {
        let height = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height ?? 0
        
        self.keyboardFrameChange(height)
    }
    /// 执行键盘显示和隐藏的通知
    @objc private func keyboardWillHide(_ sender: Notification) {
        self.keyboardFrameChange(0)
    }
}
extension ZBaseViewController {
    /// 注册第三方消息SDK发送的新消息通知
    public final func registerReceivedNewMessageNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setReceivedNewMessage(_:)), name: Notification.Names.ReceivedNewMessage, object: nil)
    }
    /// 移除第三方消息SDK发送的新消息通知
    public  final func removeReceivedNewMessageNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedNewMessage, object: nil)
    }
    /// 发出第三方消息SDK发送的新消息通知
    public final func postReceivedNewMessageNotification() {
        NotificationCenter.default.post(name: Notification.Names.ReceivedNewMessage, object: nil)
    }
}
