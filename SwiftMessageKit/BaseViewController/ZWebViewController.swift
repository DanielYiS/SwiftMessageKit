
import UIKit
import BFKit
import WebKit
import SwiftBasicKit

public class ZWebViewController: ZBaseViewController {
    
    private lazy var viewScroll: UIScrollView = {
        let item = UIScrollView.init(frame: CGRect.init(x: 0,  y: ZKit.kFullScreenY(), width: ZKit.kScreenWidth, height: ZKit.kFullScreenHeight()))
        
        item.scrollsToTop = true
        if #available(iOS 11.0, *) {
            item.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        item.scrollsToTop = false
        item.isScrollEnabled = true
        item.isUserInteractionEnabled = true
        
        return item
    }()
    private lazy var webView: ZWebView = {
        let item = ZWebView.init(frame: self.viewScroll.bounds)
        
        return item
    }()
    public var pathString: String? {
        didSet {
            self.webView.pathString = self.pathString
        }
    }
    public var urlString: String? {
        didSet {
            self.webView.urlString = self.urlString
        }
    }
    public var htmlString: String? {
        didSet {
            self.webView.htmlString = self.htmlString
        }
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.viewScroll)
        self.viewScroll.addSubview(self.webView)
        self.webView.onViewHeightChange = { height in
            self.viewScroll.contentSize = CGSize.init(width: self.viewScroll.width, height: height < self.viewScroll.height ? self.viewScroll.height : height)
        }
        self.webView.reloadData()
    }
}
