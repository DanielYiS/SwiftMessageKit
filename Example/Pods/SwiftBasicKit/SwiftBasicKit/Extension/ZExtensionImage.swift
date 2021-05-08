
import UIKit


extension UIImage {
    
    public static func withColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
    public func withAlpha(_ alpha: CGFloat) -> UIImage? {
        
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
    public func jPEGData() -> Data? {
        guard let data = self.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        return data
    }
    public func scale(orientation: UIImage.Orientation = .down) -> UIImage? {
        if let cgimage = self.cgImage {
            return UIImage.init(cgImage: cgimage, scale: 1, orientation: orientation)
        }
        return self
    }
    public static func baseImage(named: String) -> UIImage? {
        if ZKey.shared.sourceKit {
            return UIImage(named: named, in: Bundle.baseAssetBundle, compatibleWith: nil)
        }
        return UIImage.init(named: named)
    }
}
