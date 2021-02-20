import UIKit
import AVKit
import BFKit.Swift
import SwiftBasicKit.Swift
import SKPhotoBrowser.Swift

extension ZMessageViewController: MessageCellDelegate {
    
    public func didTapAvatar(in cell: MessageCollectionViewCell) {
        BFLog.info("Avatar tapped")
    }
    public func didTapMessage(in cell: MessageCollectionViewCell) {
        BFLog.info("Message tapped")
    }
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
        ZRouterKit.present(animated: true, fromVC: self, toVC: itemVC)
    }
    public func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("Top cell label tapped")
    }
    public func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("Bottom cell label tapped")
    }
    public func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("Top message label tapped")
    }
    public func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        BFLog.info("Bottom label tapped")
    }
    public func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            BFLog.info("Failed to identify message when audio cell receive tap gesture")
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
    public func didStartAudio(in cell: AudioMessageCell) {
        BFLog.info("Did start playing audio sound")
    }
    public func didPauseAudio(in cell: AudioMessageCell) {
        BFLog.info("Did pause audio sound")
    }
    public func didStopAudio(in cell: AudioMessageCell) {
        BFLog.info("Did stop audio sound")
    }
    public func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        BFLog.info("Accessory view tapped")
    }
}
