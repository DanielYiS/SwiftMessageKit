import UIKit
import BFKit.Swift
import SwiftBasicKit.Swift

extension ZMessageViewController: MessageLabelDelegate {
    
    public func didSelectAddress(_ addressComponents: [String: String]) {
        BFLog.info("Address Selected: \(addressComponents)")
    }
    public func didSelectDate(_ date: Date) {
        BFLog.info("Date Selected: \(date)")
    }
    public func didSelectPhoneNumber(_ phoneNumber: String) {
        BFLog.info("Phone Number Selected: \(phoneNumber)")
    }
    public func didSelectURL(_ url: URL) {
        BFLog.info("URL Selected: \(url)")
    }
    public func didSelectTransitInformation(_ transitInformation: [String: String]) {
        BFLog.info("TransitInformation Selected: \(transitInformation)")
    }
    public func didSelectHashtag(_ hashtag: String) {
        BFLog.info("Hashtag selected: \(hashtag)")
    }
    public func didSelectMention(_ mention: String) {
        BFLog.info("Mention selected: \(mention)")
    }
    public func didSelectCustom(_ pattern: String, match: String?) {
        BFLog.info("Custom data detector patter selected: \(pattern)")
    }
}
