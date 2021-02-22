import UIKit
import WebKit
import BFKit.Swift
import SwiftBasicKit.Swift

class ZWebView: UIView {
    var urlString: String? {
        didSet {
            guard let str = self.urlString else {
                return
            }
            guard let url = URL.init(string: str)  else {
                return
            }
            let req = URLRequest.init(url: url)
            self.wkwebView.load(req)
        }
    }
    var pathString: String? {
        didSet {
            guard let path = self.pathString else {
                return
            }
            let url = URL.init(fileURLWithPath: path)
            let req = URLRequest.init(url: url)
            self.wkwebView.load(req)
        }
    }
    var onViewHeightChange: ((_ height: CGFloat) -> Void)?
    private var estimatedProgress: Float = 0.0
    private var currentRequest: URLRequest?
    private lazy var wkwebView: WKWebView = {
        let wkConfig = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.minimumFontSize = 20
        preferences.javaScriptCanOpenWindowsAutomatically = true
        wkConfig.preferences = preferences
        
        let userContentController = WKUserContentController()
        let source = "document.cookie = 'user=value';"
        let userScript = WKUserScript.init(source: source, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        
        wkConfig.userContentController = userContentController
        
        let wkView = WKWebView.init(frame: self.bounds, configuration: wkConfig)
        
        wkView.uiDelegate = self
        wkView.navigationDelegate = self
        wkView.backgroundColor = .clear
        wkView.scrollView.isScrollEnabled = false
        wkView.scrollView.showsVerticalScrollIndicator = false
        wkView.scrollView.showsHorizontalScrollIndicator = false
        wkView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
        wkView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        
        return wkView
    }()
    
    // MARK: - 初始化
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.innerInitView()
    }
    required convenience init() {
        self.init(frame: CGRect.zero)
    }
    private func innerInitView() {
        
        self.addSubview(self.wkwebView)
    }
    deinit {
        self.wkwebView.stopLoading()
        self.wkwebView.uiDelegate = nil
        self.wkwebView.navigationDelegate = nil
        self.wkwebView.removeObserver(self, forKeyPath: "title", context: nil)
        self.wkwebView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.estimatedProgress = ((change?[NSKeyValueChangeKey.newKey] as? String)?.floatValue) ?? 0
        } else if keyPath == "title" {
            
        }
    }
}
extension ZWebView: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.currentRequest = navigationAction.request
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        BFLog.debug("decidePolicyFor navigationAction: \(self.currentRequest?.url?.absoluteString ?? "")")
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        BFLog.debug("decidePolicyFor navigationResponse")
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        BFLog.debug("didReceiveServerRedirectForProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        BFLog.debug("didStartProvisionalNavigation")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        BFLog.debug("didFinish")
        webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            BFLog.debug("document.body.scrollHeight: \(String(describing: result))")
            var webViewHeight: CGFloat = 10
            switch result {
            case is String:
                let height = result as! String
                webViewHeight = CGFloat(height.floatValue)
            case is Double:
                let height = result as! Double
                webViewHeight = CGFloat(height)
            case is Int:
                let height = result as! Int
                webViewHeight = CGFloat(height)
            case is Float:
                let height = result as! Float
                webViewHeight = CGFloat(height)
            default:
                let height = result as? CGFloat ?? 10
                webViewHeight = CGFloat(height)
            }
            let bottomHeight: CGFloat = 100
            let conventHeight = webViewHeight + bottomHeight
            self.bounds.size.height = conventHeight
            self.wkwebView.bounds.size.height = conventHeight
            self.onViewHeightChange?(conventHeight)
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        BFLog.debug("didFail: \(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        BFLog.debug("didFailProvisionalNavigation: \(error.localizedDescription)")
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        BFLog.debug("didReceive")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        BFLog.debug("webViewWebContentProcessDidTerminate")
    }
    
    // MARK: - WKScriptMessageHandler
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
    // MARK: - WKUIDelegate
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let itemVC = ZAlertSystemViewController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: L10n.continue, style: UIAlertAction.Style.default) { (action) in
            completionHandler()
        }
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(animated: true, fromVC: nil, toVC: itemVC)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let itemVC = ZAlertSystemViewController.init(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let actionDetermine = UIAlertAction.init(title: L10n.continue, style: UIAlertAction.Style.default) { (action) in
            completionHandler(true)
        }
        itemVC.addAction(actionDetermine)
        let actionCancel = UIAlertAction.init(title: L10n.cancel, style: UIAlertAction.Style.default) { (action) in
            completionHandler(false)
        }
        itemVC.addAction(actionCancel)
        ZRouterKit.present(animated: true, fromVC: nil, toVC: itemVC)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let itemVC = ZAlertSystemViewController.init(title: nil, message: prompt, preferredStyle: UIAlertController.Style.alert)
        itemVC.addTextField { (textField) in
            textField.placeholder = defaultText
        }
        let actionDetermine = UIAlertAction.init(title: L10n.continue, style: UIAlertAction.Style.default) { (action) in
            completionHandler(itemVC.textFields?.last?.text)
        }
        itemVC.addAction(actionDetermine)
        ZRouterKit.present(animated: true, fromVC: nil, toVC: itemVC)
    }
}