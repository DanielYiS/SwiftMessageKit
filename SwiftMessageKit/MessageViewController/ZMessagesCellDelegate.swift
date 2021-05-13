import UIKit
import AVKit
import BFKit.Swift
import SwiftBasicKit
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
    public func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                BFLog.debug("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard self.audioPlayManager.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            self.audioPlayManager.playSound(for: message, in: cell)
            return
        }
        if self.audioPlayManager.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if self.audioPlayManager.state == .playing {
                self.audioPlayManager.pauseSound(for: message, in: cell)
            } else {
                self.audioPlayManager.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            self.audioPlayManager.stopAnyOngoingPlaying()
            self.audioPlayManager.playSound(for: message, in: cell)
        }
    }
}
