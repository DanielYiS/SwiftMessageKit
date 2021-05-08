
import UIKit
import ESPullToRefresh

public class ZBaseSV: UIScrollView {
    
    public var onRefreshHeader: (() -> Void)?
    public var onRefreshFooter: (() -> Void)?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    deinit {
        self.es.removeRefreshHeader()
        self.es.removeRefreshFooter()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.scrollsToTop = false
        self.isScrollEnabled = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
    }
    public func addRefreshHeader() {
        self.es.addPullToRefresh { [unowned self] in
            self.onRefreshHeader?()
        }
    }
    public func addRefreshFooter() {
        self.es.addInfiniteScrolling { [unowned self] in
            self.onRefreshFooter?()
        }
        self.es.base.footer?.isHidden = true
    }
    public func endRefreshHeader() {
        self.es.stopPullToRefresh(ignoreFooter: true)
    }
    public func endRefreshHeader(_ count: Int) {
        if count < kPageCount {
            self.es.stopPullToRefresh(ignoreFooter: true)
        } else {
            self.es.stopPullToRefresh(ignoreFooter: false)
        }
    }
    public func endRefreshFooter() {
        self.es.stopLoadingMore()
    }
    public func endRefreshFooter(_ count: Int) {
        self.es.stopLoadingMore()
        if count < kPageCount {
            self.es.noticeNoMoreData()
        }
    }
    
}
