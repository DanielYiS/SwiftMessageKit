
import UIKit
import HandyJSON
import GRDB.Swift
import SwiftBasicKit

public class ZModelConfig: ZModelBase {
    
    /// 匹配价格
    public var match_price_both: Int = 0
    /// 匹配价格
    public var match_price_male: Int = 0
    /// 匹配价格
    public var match_price_female: Int = 0
    /// 版本验证码
    public var version: String = ""
    /// 消息价格
    public var message_price: Int = 0
    /// appid
    public var agora_app_id: String = ""
    /// 聊天礼物
    public var chat_gift: Bool = false
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else { return }
        
        self.match_price_both = model.match_price_both
        self.match_price_male = model.match_price_male
        self.match_price_female = model.match_price_female
        self.version = model.version
        self.message_price = model.message_price
        self.agora_app_id = model.agora_app_id
        self.chat_gift = model.chat_gift
    }
    public required init(row: Row) {
        super.init(row: row)
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.match_price_both <-- "match_price.both"
        mapper <<< self.match_price_male <-- "match_price.male"
        mapper <<< self.match_price_female <-- "match_price.female"
        mapper <<< self.version <-- "version"
        mapper <<< self.message_price <-- "message_price"
        mapper <<< self.agora_app_id <-- "agora_app_id"
        mapper <<< self.chat_gift <-- "chat_gift"
    }
}
