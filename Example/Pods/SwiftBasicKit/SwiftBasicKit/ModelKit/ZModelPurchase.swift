
import UIKit
import HandyJSON
import GRDB.Swift
import SwiftBasicKit

public enum ZRechargeType: Int, HandyJSONEnum {
    case apa = 1
    case gpa = 2
    case ppa = 3
}
public class ZModelPurchase: ZModelBase {
    
    /// ID, 1:apa, 2:gpa, 3:ppa
    public var gid: ZRechargeType = .apa
    /// 名称
    public var name: String = ""
    /// 选中
    public var select: String = ""
    /// 默认
    public var normal: String = ""
    /// 内购项
    public var items: [ZModelRecharge]?
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.gid = model.gid
        self.name = model.name
        self.select = model.select
        self.normal = model.normal
        if let array = model.items {
            self.items = [ZModelRecharge]()
            array.forEach { (item) in
                self.items?.append(ZModelRecharge.init(instance: item))
            }
        }
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
        mapper <<< self.name <-- "name"
        mapper <<< self.select <-- "icon.selected"
        mapper <<< self.normal <-- "icon.normal"
        mapper <<< self.items <-- "items"
    }
}
