
import UIKit
import SwiftBasicKit

public struct ZAlertView {
    
    public var useCustomStyle: Bool = true
    public var backgroundColor: String = "#2D2638"
    public var attributedContentStyle: UIBlurEffect.Style = .dark
    public var attributedButtonColor: String = "#7037E9"
    public var attributedCancelColor: String = "#FFFFFF"
    public var attributedTitleColor: String = "#FFFFFF"
    public var attributedMessageColor: String = "#FFFFFF"
    
    public static var shared = ZAlertView()
    
    /// 显示一个弹框  回调row 0 cancel 1 done
    public static func showAlertView(vc: UIViewController? = nil, title: String? = nil, message: String, button: String? = nil, cancel: String? = nil, completeBlock: ( (_ row: Int) -> Void)?) {
        
        let itemVC = ZAlertSystemViewController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if ZAlertView.shared.useCustomStyle {
            itemVC.view.backgroundColor = ZAlertView.shared.backgroundColor.color.withAlphaComponent(0.8)
            itemVC.attributedBackgroundColor = ZAlertView.shared.backgroundColor.color
            itemVC.attributedContentStyle = ZAlertView.shared.attributedContentStyle
            itemVC.attributedButtonColor = ZAlertView.shared.attributedButtonColor.color
            itemVC.attributedCancelColor = ZAlertView.shared.attributedCancelColor.color
            itemVC.attributedTitleColor = ZAlertView.shared.attributedTitleColor.color
            itemVC.attributedMessageColor = ZAlertView.shared.attributedMessageColor.color
        }
        let actionContinue = UIAlertAction.init(title: button ?? L10n.btnContinue, style: UIAlertAction.Style.default) { (action) in
            completeBlock?(action.tag)
        }
        actionContinue.tag = 1
        itemVC.addAction(actionContinue)
        let actionCancel = UIAlertAction.init(title: cancel ?? L10n.btnCancel, style: UIAlertAction.Style.cancel) { (action) in
            completeBlock?(action.tag)
        }
        actionCancel.tag = 1000
        itemVC.addAction(actionCancel)
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: true, completion: nil)
    }
    /// 显示一个提示框
    public static func showAlertView(vc: UIViewController? = nil, message: String, completeBlock: ( () -> Void)? = nil) {
        
        let itemVC = ZAlertSystemViewController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        if ZAlertView.shared.useCustomStyle {
            itemVC.view.backgroundColor = ZAlertView.shared.backgroundColor.color.withAlphaComponent(0.8)
            itemVC.attributedBackgroundColor = ZAlertView.shared.backgroundColor.color
            itemVC.attributedContentStyle = ZAlertView.shared.attributedContentStyle
            itemVC.attributedButtonColor = ZAlertView.shared.attributedButtonColor.color
            itemVC.attributedCancelColor = ZAlertView.shared.attributedCancelColor.color
            itemVC.attributedTitleColor = ZAlertView.shared.attributedTitleColor.color
            itemVC.attributedMessageColor = ZAlertView.shared.attributedMessageColor.color
        }
        let actionDetermine = UIAlertAction.init(title: L10n.btnContinue, style: UIAlertAction.Style.cancel) { (action) in
            completeBlock?()
        }
        actionDetermine.tag = 1000
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: true, completion: nil)
    }
    /// 显示多个ActionSheet
    public static func showActionSheetView(vc: UIViewController? = nil, title: String? = nil, message: String? = nil, buttons: [String], completeBlick: ( (_ index: Int) -> Void)?) {
        
        let itemVC = ZAlertSheetViewController.init()
        itemVC.label = title
        itemVC.message = message
        itemVC.buttons.append(contentsOf: buttons)
        itemVC.onButtonItemClick = { row in
            let tag = row
            DispatchQueue.DispatchAfter(after: 0.5, handler: {
                completeBlick?(tag)
            })
        }
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: false, completion: nil)
    }
}
