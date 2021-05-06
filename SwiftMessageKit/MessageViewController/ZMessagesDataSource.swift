import UIKit
import BFKit.Swift
import SwiftBasicKit

extension ZMessageViewController: MessagesDataSource {
    
    public func currentSender() -> SenderType {
        return self.loginUser
    }
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.arrayMessage.count
    }
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.arrayMessage[indexPath.section]
    }
    public func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    public func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
}
