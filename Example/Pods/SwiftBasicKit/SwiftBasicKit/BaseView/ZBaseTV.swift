
import UIKit
import ESPullToRefresh

public class ZBaseTV: UITableView {
    
    public var onRefreshHeader: (() -> Void)?
    public var onRefreshFooter: (() -> Void)?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required convenience init(frame: CGRect) {
        self.init(frame: frame, style: UITableView.Style.plain)
    }
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.setupViewUI()
    }
    deinit {
        self.es.removeRefreshHeader()
        self.es.removeRefreshFooter()
    }
    private func setupViewUI() {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.estimatedRowHeight = UITableView.automaticDimension
        self.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        self.separatorColor = .clear
        
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
    public  func endRefreshHeader(_ count: Int = 0) {
        if count < kPageCount {
            self.es.stopPullToRefresh(ignoreFooter: true)
        } else {
            self.es.stopPullToRefresh(ignoreFooter: false)
        }
        self.imageStatus.alpha = count == 0 ? 1 : 0
        self.lbStatus.alpha = count == 0 ? 1 : 0
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
    public func addBackgroundStatus(text: String, color: UIColor) {
        self.lbStatus.text = text
        self.lbStatus.textColor = color
        self.viewBG.addSubview(self.imageStatus)
        self.viewBG.addSubview(self.lbStatus)
        self.backgroundView = self.viewBG
        self.backgroundView?.frame = self.bounds
    }
    private lazy var viewBG: UIView = {
        let item = UIView.init(frame: self.bounds)
        
        item.isUserInteractionEnabled = true
        item.backgroundColor = .clear
        
        return item
    }()
    private lazy var imageStatus: UIImageView = {
        let item = UIImageView.init(image: UIImage.init(named: "defaultNothing"))
        
        item.isUserInteractionEnabled = false
        let itemW = (item.image?.size.width ?? 0)
        let itemH = (item.image?.size.height ?? 0)
        item.frame = CGRect.init(x: self.frame.size.width/2 - itemW/2, y: self.frame.size.height/2 - itemH/2, width: itemW, height: itemH)
        
        return item
    }()
    private lazy var lbStatus: UILabel = {
        let item = UILabel.init(frame: CGRect.init(x: 0, y: self.imageStatus.frame.origin.y + self.imageStatus.frame.size.height + 20, width: self.frame.size.width, height: 35))
        
        item.font = UIFont.boldSystemFont(ofSize: 24)
        item.textAlignment = .center
        item.isUserInteractionEnabled = false
        item.text = L10n.labelNoData
        item.textColor = .black
        item.adjustsFontSizeToFitWidth = true
        
        return item
    }()
}
