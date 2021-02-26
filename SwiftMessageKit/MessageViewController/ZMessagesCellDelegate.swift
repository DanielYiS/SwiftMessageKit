import UIKit
import AVKit
import BFKit.Swift
import SwiftBasicKit.Swift
import SKPhotoBrowser.Swift

extension ZMessageViewController: MessageCellDelegate {
    
    public func didTapImage(in cell: MessageCollectionViewCell) {
        BFLog.info("Image tapped")
        guard let mediaCell = cell as? MediaMessageCell, let image = mediaCell.imageView.image else {
            return
        }
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(image)
        images.append(photo)
        SKPhotoBrowserOptions.displayStatusbar = false
        let itemVC = ZPhotoBrowserViewController(photos: images)
        itemVC.initializePageIndex(0)
        ZRouterKit.present(toVC: itemVC, fromVC: self, animated: true, completion: nil)
    }
}
