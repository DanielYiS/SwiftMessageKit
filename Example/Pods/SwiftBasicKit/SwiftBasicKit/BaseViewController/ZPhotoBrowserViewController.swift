
import UIKit
import SKPhotoBrowser

public class ZPhotoBrowserViewController: SKPhotoBrowser {
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ZCurrentVC.shared.currentPresentVC = self
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ZCurrentVC.shared.currentPresentVC = nil
    }
}
