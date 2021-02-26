
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
            self.dismiss(animated: true, completion: nil)
        } else {
            ZRouterKit.pop(fromVC: self)
        }
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
        item.addTarget(self, action: #selector(self.btnNavBarRightClick), for: UIControl.Event.touchUpInside)
        item.frame = CGRect.init(x: 0, y: 0, width: 50, height: 45)
        
        let btnRightItem = UIBarButtonItem.init(customView: item)
        
        self.navigationItem.rightBarButtonItem = btnRightItem
    }
}
