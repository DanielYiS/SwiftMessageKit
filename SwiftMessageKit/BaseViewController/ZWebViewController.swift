
import UIKit
import BFKit
import WebKit
import SwiftBasicKit

class ZWebViewController: ZBaseViewController {
    
    private lazy var viewScroll: UIScrollView = {
        let item = UIScrollView.init(frame: CGRect.init(x: 0,  y: ZKit.kFullScreenY(), width: ZKit.kScreenWidth, height: ZKit.kFullScreenHeight()))
        
        item.scrollsToTop = true
        if #available(iOS 11.0, *) {
            item.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        item.scrollsToTop = false
        item.isScrollEnabled = true
        item.isUserInteractionEnabled = true
        item.backgroundColor = ZColor.shared.BackgroundColor
        
        return item
    }()
    private lazy var webView: ZWebView = {
        let item = ZWebView.init(frame: self.viewScroll.bounds)
        
        return item
    }()
    var pathString: String?
    var urlString: String?
    var isDismiss: Bool = false
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.innerInitView()
        self.innerInitEvent()
        self.innerInitUrl()
        self.innerInitPath()
    }
    private func innerInitView() {
        
        self.view.addSubview(self.viewScroll)
        self.viewScroll.addSubview(self.webView)
    }
    private func innerInitUrl() {
        self.webView.urlString = self.urlString
    }
    private func innerInitPath() {
        self.webView.pathString = self.pathString
    }
    private func innerInitEvent() {
        self.webView.onViewHeightChange = { height in
            self.viewScroll.contentSize = CGSize.init(width: self.viewScroll.width, height: height < self.viewScroll.height ? self.viewScroll.height : height)
        }
    }
}
