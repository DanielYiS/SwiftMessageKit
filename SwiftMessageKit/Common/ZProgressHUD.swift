
import UIKit
import PKHUD.Swift
import Toast_Swift.Swift
import SwiftBasicKit.Swift

/// 等待UI
public struct ZProgressHUD {
    
    public static var shared = ZProgressHUD.init()
    
    public var hudLabelSize: CGFloat = 15
    public var hudImage: UIImage? = UIImage.init(named: "message_voice3")
    public var hudBGColor: UIColor = .white
    public var hudTextColor: UIColor = .black
    public var hudLabelText: String = L10n.hudLabelText
    public var messageColor: UIColor = .white
    
    public static func dismiss() {
        PKHUD.sharedHUD.hide()
    }
    public static func show(vc: UIViewController?) {
        let contentView = PKHUDProgressView.init()
        contentView.backgroundColor = ZProgressHUD.shared.hudBGColor
        contentView.imageView.image = ZProgressHUD.shared.hudImage
        contentView.subtitleLabel.textColor = ZProgressHUD.shared.hudTextColor
        contentView.subtitleLabel.font = UIFont.systemFont(ofSize: ZProgressHUD.shared.hudLabelSize)
        contentView.subtitleLabel.text = ZProgressHUD.shared.hudLabelText
        PKHUD.sharedHUD.contentView = contentView
        PKHUD.sharedHUD.show(onView: nil)
    }
    public static func showMessage(vc: UIViewController?, text: String, position: ToastPosition = .bottom) {
        ToastManager.shared.position = position
        var style = ToastStyle()
        style.messageColor = ZProgressHUD.shared.messageColor
        if vc != nil {
            vc?.view.makeToast(text, duration: ZKey.number.toastWaitTime, style: style)
            return
        }
        if ZCurrentVC.shared.currentPresentVC != nil {
            ZCurrentVC.shared.currentPresentVC?.view.makeToast(text, duration: ZKey.number.toastWaitTime, style: style)
            return
        }
        if ZCurrentVC.shared.currentVC != nil {
            ZCurrentVC.shared.currentVC?.view.makeToast(text, duration: ZKey.number.toastWaitTime, style: style)
            return
        }
        if ZCurrentVC.shared.rootVC?.viewControllers.last != nil {
            ZCurrentVC.shared.rootVC?.viewControllers.last?.view.makeToast(text, duration: ZKey.number.toastWaitTime, style: style)
            return
        }
        UIApplication.shared.keyWindow?.makeToast(text, duration: ZKey.number.toastWaitTime, style: style)
    }
}
