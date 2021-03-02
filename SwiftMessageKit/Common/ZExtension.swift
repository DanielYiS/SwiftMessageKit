import UIKit
import BFKit
import SnapKit
import Kingfisher
import SwiftBasicKit

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
