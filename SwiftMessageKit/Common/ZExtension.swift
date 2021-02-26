import UIKit
import BFKit.Swift
import SnapKit.Swift
import Kingfisher.Swift
import SwiftBasicKit.Swift

extension Notification {
    public struct Names {
        /// 接收到聊天消息
        public static let ReceivedNewMessage = Notification.Name.init(rawValue: "ReceivedNewMessage")
        /// 接收到事件消息
        public static let ReceivedEventMessage = Notification.Name.init(rawValue: "ReceivedEventMessage")
        /// 显示用户详情页面
        public static let ShowUserDetailVC = Notification.Name.init(rawValue: "ShowUserDetailVC")
        /// 显示充值提醒页面
        public static let ShowRechargeReminderVC = Notification.Name.init(rawValue: "ShowRechargeReminderVC")
        /// 声网上传一张图片
        public static let AgoraUploadImage = Notification.Name.init(rawValue: "AgoraUploadImage")
        /// 声网上传一个文件
        public static let AgoraUploadFile = Notification.Name.init(rawValue: "AgoraUploadFile")
        /// 声网发送一条消息
        public static let AgoraSendMessage = Notification.Name.init(rawValue: "AgoraSendMessage")
    }
}
extension UIImage {
    internal static func bundledImage(named name: String) -> UIImage {
        let primaryBundle = Bundle.main
        if let image = UIImage(named: name, in: primaryBundle, compatibleWith: nil) {
            return image
        } else if
            let subBundleUrl = primaryBundle.url(forResource: "SwiftMessageKit", withExtension: "bundle"),
            let subBundle = Bundle(url: subBundleUrl),
            let image = UIImage(named: name, in: subBundle, compatibleWith: nil)
        {
            return image
        }
        return UIImage()
    }
}
extension UIImageView {
    
    private struct AssociatedKey {
        static var viewUrl = "viewUrl"
        static var viewActivityIndicator = "viewActivityIndicator"
    }
    var currentUrlStr: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewUrl) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewUrl, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var aiView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewActivityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewActivityIndicator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func setImageWitUrl(_ strUrl: String, _ placeholder: UIImage?) {
        
        self.clipsToBounds = true
        self.contentMode = UIView.ContentMode.scaleAspectFill
        if strUrl.count == 0 {
            self.image = placeholder
            return
        }
        guard let url = URL.init(string: strUrl) else {
            return
        }
        self.currentUrlStr = strUrl
        if self.aiView == nil {
            let aiView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
            
            self.aiView = aiView
            self.addSubview(self.aiView!)
            self.bringSubviewToFront( self.aiView!)
            
            self.aiView?.snp.remakeConstraints { (make) in
                make.center.equalTo(self.snp.center)
                make.width.height.equalTo(30)
            }
        }
        self.aiView?.startAnimating()
        let imageResource = ImageResource.init(downloadURL: url, cacheKey: url.absoluteString.md5())
        let options = [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.25))]
        self.kf.setImage(with: imageResource, placeholder: placeholder, options: options, progressBlock: { (receivedSize, totalSize) in
            
        }, completionHandler: { [weak self] (result) in
            self?.aiView?.stopAnimating()
            self?.aiView?.removeFromSuperview()
            self?.aiView = nil
            switch result {
            case .success(let rst): self?.image = rst.image
            case .failure(_): BFLog.debug("download image error: \(self?.currentUrlStr ?? "")")
            }
        })
    }
}
extension String {
    
    var length: Int {
        return self.count
    }
    var integerValue: Int {
        return Int(NSString(string: self).integerValue)
    }
    var longLongValue: Int64 {
        return Int64(NSString(string: self).longLongValue)
    }
    var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    func isEqual(_ value: String) -> Bool {
        return self == value
    }
    func toRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
        else { return nil }
        return from ..< to
    }
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: utf16),
              let to = range.upperBound.samePosition(in: utf16) else {
            return nil
        }
        let location = utf16.distance(from: utf16.startIndex, to: from)
        let length = utf16.distance(from: from, to: to)
        
        return NSRange(location: location, length: length)
    }
    func getWidth(_ font: UIFont, height: CGFloat = 22) -> CGFloat {
        
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.width)
    }
    func getHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.height)
    }
    func getOneHeight(_ font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: " ").boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(rect.height)
    }
}
extension CGRect {
    var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            var newFrame = self
            newFrame.origin.x = newValue
            self = newFrame
        }
    }
    var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            var newFrame = self
            newFrame.origin.y = newValue
            self = newFrame
        }
    }
    var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            var newFrame = self
            newFrame.size.width = newValue
            self = newFrame
        }
    }
    var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            var newFrame = self
            newFrame.size.height = newValue
            self = newFrame
        }
    }
}
extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var newFrame = self.frame
            newFrame.origin.x = newValue
            self.frame = newFrame
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var newFrame = self.frame
            newFrame.origin.y = newValue
            self.frame = newFrame
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
    }
    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            x = newValue.x
            y = newValue.y
        }
    }
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    func screenShots() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension Error {
    
    var code: Int {
        return (self as NSError).code
    }
    var domain: String {
        return (self as NSError).domain
    }
}
extension UIFont {
    
    static func systemFont(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: (size))
    }
    static func boldSystemFont(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: (size))
    }
}
extension UILabel {
    
    var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.systemFont(newValue)
        }
    }
    var boldSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.boldSystemFont(newValue)
        }
    }
}
extension UIImage {
    
    class func withColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContext(self.size)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx?.scaleBy(x: 1.0, y: -1.0)
        ctx?.translateBy(x: 0, y: -rect.size.height)
        ctx?.setBlendMode(CGBlendMode.multiply)
        ctx?.setAlpha(alpha)
        ctx?.draw(self.cgImage!, in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func getJPEGData() -> Data? {
        guard let data = self.jpegData(compressionQuality: ZKey.number.pngToJpegCompress) else {
            return nil
        }
        return data
    }
}

// MARK: - Properties
extension UICollectionView {
    
    /// SwifterSwift: Index path of last item in collectionView.
    var indexPathForLastItem: IndexPath? {
        return indexPathForLastItem(inSection: lastSection)
    }
    
    /// SwifterSwift: Index of last section in collectionView.
    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
}

// MARK: - Methods
extension UICollectionView {
    
    /// SwifterSwift: Number of all items in all sections of collectionView.
    ///
    /// - Returns: The count of all rows in the collectionView.
    func numberOfItems() -> Int {
        var section = 0
        var itemsCount = 0
        while section < numberOfSections {
            itemsCount += numberOfItems(inSection: section)
            section += 1
        }
        return itemsCount
    }
    
    /// SwifterSwift: IndexPath for last item in section.
    ///
    /// - Parameter section: section to get last item in.
    /// - Returns: optional last indexPath for last item in section (if applicable).
    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < numberOfSections else {
            return nil
        }
        guard numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
    }
    
    /// SwifterSwift: Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// SwifterSwift: Dequeue reusable UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionViewCell object with associated class name.
    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionViewCell for \(String(describing: name)), make sure the cell is registered with collection view")
        }
        return cell
    }
    
    /// SwifterSwift: Dequeue reusable UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    ///   - indexPath: location of cell in collectionView.
    /// - Returns: UICollectionReusableView object with associated class name.
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UICollectionReusableView for \(String(describing: name)), make sure the view is registered with collection view")
        }
        return cell
    }
    
    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(supplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UICollectionViewCell using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the collectionView cell.
    ///   - name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(nib: UINib?, forCellWithClass name: T.Type) {
        register(nib, forCellWithReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UICollectionViewCell using class name.
    ///
    /// - Parameter name: UICollectionViewCell type.
    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UICollectionReusableView using class name.
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the reusable view.
    ///   - kind: the kind of supplementary view to retrieve. This value is defined by the layout object.
    ///   - name: UICollectionReusableView type.
    func register<T: UICollectionReusableView>(nib: UINib?, forSupplementaryViewOfKind kind: String, withClass name: T.Type) {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UICollectionViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UICollectionViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    func register<T: UICollectionViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
    
    /// SwifterSwift: Safely scroll to possibly invalid IndexPath
    ///
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to
    ///   - scrollPosition: Scroll position
    ///   - animated: Whether to animate or not
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0 &&
                indexPath.section >= 0 &&
                indexPath.section < numberOfSections &&
                indexPath.item < numberOfItems(inSection: indexPath.section) else {
            return
        }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    /// SwifterSwift: Check whether IndexPath is valid within the CollectionView
    ///
    /// - Parameter indexPath: An IndexPath to check
    /// - Returns: Boolean value for valid or invalid IndexPath
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.item >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.item < numberOfItems(inSection: indexPath.section)
    }
    
}

// MARK: - Properties
extension UITableView {
    
    /// SwifterSwift: Index path of last row in tableView.
    var indexPathForLastRow: IndexPath? {
        guard let lastSection = lastSection else { return nil }
        return indexPathForLastRow(inSection: lastSection)
    }
    
    /// SwifterSwift: Index of last section in tableView.
    var lastSection: Int? {
        return numberOfSections > 0 ? numberOfSections - 1 : nil
    }
    
}

// MARK: - Methods
extension UITableView {
    
    /// SwifterSwift: Number of all rows in all sections of tableView.
    ///
    /// - Returns: The count of all rows in the tableView.
    func numberOfRows() -> Int {
        var section = 0
        var rowCount = 0
        while section < numberOfSections {
            rowCount += numberOfRows(inSection: section)
            section += 1
        }
        return rowCount
    }
    
    /// SwifterSwift: IndexPath for last row in section.
    ///
    /// - Parameter section: section to get last row in.
    /// - Returns: optional last indexPath for last row in section (if applicable).
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard numberOfSections > 0, section >= 0 else { return nil }
        guard numberOfRows(inSection: section) > 0  else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    /// SwifterSwift: Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    /// SwifterSwift: Remove TableFooterView.
    func removeTableFooterView() {
        tableFooterView = nil
    }
    
    /// SwifterSwift: Remove TableHeaderView.
    func removeTableHeaderView() {
        tableHeaderView = nil
    }
    
    /// SwifterSwift: Scroll to bottom of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// SwifterSwift: Scroll to top of TableView.
    ///
    /// - Parameter animated: set true to animate scroll (default is true).
    func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    /// SwifterSwift: Dequeue reusable UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
    
    /// SwifterSwift: Dequeue reusable UITableViewCell using class name for indexPath
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - indexPath: location of cell in tableView.
    /// - Returns: UITableViewCell object with associated class name.
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("Couldn't find UITableViewCell for \(String(describing: name)), make sure the cell is registered with table view")
        }
        return cell
    }
    
    /// SwifterSwift: Dequeue reusable UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    /// - Returns: UITableViewHeaderFooterView object with associated class name.
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass name: T.Type) -> T {
        guard let headerFooterView = dequeueReusableHeaderFooterView(withIdentifier: String(describing: name)) as? T else {
            fatalError("Couldn't find UITableViewHeaderFooterView for \(String(describing: name)), make sure the view is registered with table view")
        }
        return headerFooterView
    }
    
    /// SwifterSwift: Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the header or footer view.
    ///   - name: UITableViewHeaderFooterView type.
    func register<T: UITableViewHeaderFooterView>(nib: UINib?, withHeaderFooterViewClass name: T.Type) {
        register(nib, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UITableViewHeaderFooterView using class name
    ///
    /// - Parameter name: UITableViewHeaderFooterView type
    func register<T: UITableViewHeaderFooterView>(headerFooterViewClassWith name: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UITableViewCell using class name
    ///
    /// - Parameter name: UITableViewCell type
    func register<T: UITableViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UITableViewCell using class name
    ///
    /// - Parameters:
    ///   - nib: Nib file used to create the tableView cell.
    ///   - name: UITableViewCell type.
    func register<T: UITableViewCell>(nib: UINib?, withCellClass name: T.Type) {
        register(nib, forCellReuseIdentifier: String(describing: name))
    }
    
    /// SwifterSwift: Register UITableViewCell with .xib file using only its corresponding class.
    ///               Assumes that the .xib filename and cell class has the same name.
    ///
    /// - Parameters:
    ///   - name: UITableViewCell type.
    ///   - bundleClass: Class in which the Bundle instance will be based on.
    func register<T: UITableViewCell>(nibWithCellClass name: T.Type, at bundleClass: AnyClass? = nil) {
        let identifier = String(describing: name)
        var bundle: Bundle?
        
        if let bundleName = bundleClass {
            bundle = Bundle(for: bundleName)
        }
        
        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    
    /// SwifterSwift: Check whether IndexPath is valid within the tableView
    ///
    /// - Parameter indexPath: An IndexPath to check
    /// - Returns: Boolean value for valid or invalid IndexPath
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.row >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.row < numberOfRows(inSection: indexPath.section)
    }
    
    /// SwifterSwift: Safely scroll to possibly invalid IndexPath
    ///
    /// - Parameters:
    ///   - indexPath: Target IndexPath to scroll to
    ///   - scrollPosition: Scroll position
    ///   - animated: Whether to animate or not
    func safeScrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) {
        guard indexPath.section < numberOfSections else { return }
        guard indexPath.row < numberOfRows(inSection: indexPath.section) else { return }
        scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
    }
    
}
