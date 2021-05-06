
import UIKit
import SKPhotoBrowser

open class ZPhotoBrowserViewController: SKPhotoBrowser {
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ZCurrentVC.shared.currentPresentVC = self
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ZCurrentVC.shared.currentPresentVC = nil
    }
}
