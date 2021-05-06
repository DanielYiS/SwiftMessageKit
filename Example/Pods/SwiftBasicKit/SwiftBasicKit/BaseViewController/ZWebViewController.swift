
import UIKit
import BFKit
import WebKit

public class ZWebViewController: ZBaseViewController {
    
    private lazy var webView: ZWebView = {
        let item = ZWebView.init(frame: CGRect.mainRemoveTop())
        
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
        
        self.view.addSubview(self.webView)
        
        self.webView.reloadData()
    }
}
