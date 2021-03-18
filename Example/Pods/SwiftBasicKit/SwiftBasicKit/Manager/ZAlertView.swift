
import UIKit
import SwiftBasicKit

public struct ZAlertView {
    
    /// 显示一个弹框  回调row 0 cancel 1 done
    public static func showAlertView(vc: UIViewController? = nil, title: String? = nil, message: String, done: String? = nil, cancel: String? = nil, completeBlock: ( (_ row: Int) -> Void)?) {
        
        let itemVC = ZAlertSystemViewController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: done ?? L10n.btnContinue, style: UIAlertAction.Style.default) { (action) in
            completeBlock?(action.tag)
        }
        actionDetermine.tag = 1
        itemVC.addAction(actionDetermine)
        let actionCancel = UIAlertAction.init(title: cancel ?? L10n.btnCancel, style: UIAlertAction.Style.default) { (action) in
            completeBlock?(action.tag)
        }
        actionCancel.tag = 0
        itemVC.addAction(actionCancel)
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: true, completion: nil)
    }
    /// 显示一个提示框
    public static func showAlertView(vc: UIViewController? = nil, message: String, completeBlock: ( () -> Void)? = nil) {
        
        let itemVC = ZAlertSystemViewController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: L10n.btnContinue, style: UIAlertAction.Style.default) { (action) in
            completeBlock?()
        }
        actionDetermine.tag = 1
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: true, completion: nil)
    }
    /// 显示多个ActionSheet
    public static func showActionSheetView(vc: UIViewController? = nil, title: String? = nil, message: String? = nil, buttons: [String], completeBlick: ( (_ index: Int) -> Void)?) {
        
        let itemVC = ZAlertSystemViewController.init(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for (i, button) in buttons.enumerated() {
            let action = UIAlertAction.init(title: button, style: UIAlertAction.Style.default) { (action) in
                completeBlick?(action.tag)
            }
            action.tag = i
            itemVC.addAction(action)
        }
        let actionCancel = UIAlertAction.init(title: L10n.btnCancel, style: UIAlertAction.Style.cancel) { (action) in
            
        }
        itemVC.addAction(actionCancel)
        ZRouterKit.present(toVC: itemVC, fromVC: vc, animated: true, completion: nil)
    }
}
