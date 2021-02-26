import UIKit
import HandyJSON
import GRDB.Swift
import CoreLocation
import AVFoundation

/// 用户对象
struct ZModelMessageUser: SenderType, Equatable {
    /// 用户id
    var senderId: String
    /// 用户昵称
    var displayName: String
    /// 用户头像
    var head: String
    /// 角色
    var role: Int
    /// 性别
    var gender: Int
}
/// 聊天消息对象
struct ZModelMessageType: MessageType {
    
    var id: Int = 0
    /// 发送者
    var sender: SenderType {
        return sendUser
    }
    var sendUser: ZModelMessageUser
    
    var messageId: String
    
    var sentDate: Date
    var sentTime: TimeInterval = 0
    var kind: MessageKind
    /// 接收者
    var receive: SenderType {
        return receiveUser
    }
    var receiveUser: ZModelMessageUser
    
    private init(kind: MessageKind, sender: ZModelMessageUser, receive: ZModelMessageUser, messageId: String, sentDate: Date) {
        self.kind = kind
        self.sendUser = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.receiveUser = receive
        self.messageId = messageId
    }
    /// 普通文本消息
    init(text: String, sender: ZModelMessageUser, receive: ZModelMessageUser, messageId: String, sentDate: Date) {
        self.init(kind: .text(text), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 富文本消息
    init(attributedText: NSAttributedString, sender: ZModelMessageUser, receive: ZModelMessageUser, messageId: String, sentDate: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 图片文件
    init(image: UIImage?, imageUrl: URL, sender: ZModelMessageUser, receive: ZModelMessageUser, messageId: String, sentDate: Date) {
        var mediaItem = ImageMediaItem(image: image)
        mediaItem.url = imageUrl
        self.init(kind: .photo(mediaItem), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 定位消息
    init(location: CLLocation, sender: ZModelMessageUser, receive: ZModelMessageUser, messageId: String, sentDate: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
    /// 音频文件
    init(audioURL: URL, sender: ZModelMessageUser, receive: ZModelMessageUser, messageId: String, sentDate: Date) {
        let audioItem = MockAudiotem(url: audioURL)
        self.init(kind: .audio(audioItem), sender: sender, receive: receive, messageId: messageId, sentDate: sentDate)
    }
}
/// 消息定位对象
private struct CoordinateItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: (200), height: (200))
    }
}
/// 消息图片对象
private struct ImageMediaItem: MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage?) {
        if let image = image {
            self.image = image
            var imageWidth: CGFloat = (200)
            if image.size.width < imageWidth {
                imageWidth = image.size.width
            }
            var imageHeight: CGFloat = (200)
            if image.size.height < imageHeight {
                imageHeight = image.size.height
            }
            self.size = CGSize(width: imageWidth, height: imageHeight)
        } else {
            self.size = CGSize.zero
        }
        self.placeholderImage = UIImage.init()
    }
}
/// 消息音频对象
private struct MockAudiotem: AudioItem {
    
    var url: URL
    var size: CGSize
    var duration: Float
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 160, height: 35)
        let options = [AVURLAssetPreferPreciseDurationAndTimingKey:true]
        let audioAsset = AVURLAsset.init(url: url, options: options)
        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
    }
}
