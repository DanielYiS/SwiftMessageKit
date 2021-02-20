
import UIKit
import SwiftBasicKit.Swift

extension ZMessageViewController {
    
    public final func setNavBarBackBlack() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.backBarButtonItem = nil
        
        let item = UIButton.init(type: UIButton.ButtonType.custom)
        
        item.isUserInteractionEnabled = true
        item.contentHorizontalAlignment = .left
        item.setImage(self.imageBack, for: .normal)
        item.setImage(self.imageBack, for: .highlighted)
        item.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 15)
        item.addTarget(self, action: #selector(btnNavBarBackClick), for: .touchUpInside)
        item.frame = CGRect.init(x: 0, y: 0, width: 50, height: 45)
        
        let btnBackItem = UIBarButtonItem.init(customView: item)
        self.navigationItem.leftBarButtonItem = btnBackItem
    }
    @objc private func btnNavBarBackClick() {
        let vcCount: Int = self.navigationController?.viewControllers.count ?? 0
        if vcCount <= 1 {
            ZRouterKit.dismiss(fromVC: self)
        } else {
            ZRouterKit.pop(fromVC: self)
        }
    }
}
extension ZMessageViewController {
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
extension ZMessageViewController {
    /// IM的新消息通知
    public final func registerReceivedNewMessageNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setReceivedNewMessage(_:)), name: Notification.Names.ReceivedNewMessage, object: nil)
    }
    /// IM的新消息通知
    public final func removeReceivedNewMessageNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Names.ReceivedNewMessage, object: nil)
    }
    /// IM的新消息通知
    public final func postReceivedNewMessageNotification() {
        NotificationCenter.default.post(name: Notification.Names.ReceivedNewMessage, object: nil)
    }
}
