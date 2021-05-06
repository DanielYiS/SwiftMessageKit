
import UIKit
import HandyJSON
import GRDB.Swift
import SwiftBasicKit

public class ZModelRecharge: ZModelBase {
    
    /// ID, 1:apa, 2:gpa, 3:ppa
    public var gid: ZRechargeType = .apa
    /// 内购ID
    public var code: String = ""
    /// 金额 $
    public var price: Double = 0
    /// 原本金额 $
    public var original_price: Double = 0
    /// 实得数
    public var token_amount: Int = 0
    /// 原本数
    public var original_token_amount: Int = 0
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.gid = model.gid
        self.code = model.code
        self.price = model.price
        self.original_price = model.original_price
        self.token_amount = model.token_amount
        self.original_token_amount = model.original_token_amount
    }
    public required init(row: Row) {
        super.init(row: row)
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.gid <-- "gid"
        mapper <<< self.code <-- "code"
        mapper <<< self.price <-- "price"
        mapper <<< self.original_price <-- "original_price"
        mapper <<< self.token_amount <-- "token_amount"
        mapper <<< self.original_token_amount <-- "original_token_amount"
    }
}
