
import UIKit
import BFKit
import SnapKit
import Kingfisher

extension UIImageView {
    
    private struct AssociatedKey {
        static var viewUrl = "viewUrl"
        static var viewActivityIndicator = "viewActivityIndicator"
    }
    public var currentUrlStr: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewUrl) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewUrl, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var aiView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewActivityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewActivityIndicator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public func setPhotoWitUrl(strUrl: String, placeholder: UIImage? = UIImage.baseImage(named: "default_avatar")) {
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        if let image = UIImage.init(named: strUrl) {
            self.image = image
            return
        }
        let path = ZLocalFileApi.imageFileFolder.appendingPathComponent(strUrl)
        if let image = UIImage.init(contentsOfFile: path.path) {
            self.image = image
            return
        }
        self.setImageWitUrl(strUrl: strUrl, placeholder: placeholder)
    }
    public func setImageWitUrl(strUrl: String, placeholder: UIImage? = UIImage.baseImage(named: "default_image")) {
        
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        if strUrl.count == 0 {
            self.image = placeholder
            return
        }
        guard let url = URL.init(string: strUrl) else {
            return
        }
        self.currentUrlStr = strUrl
        if self.aiView == nil {
            let aiView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
            
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
