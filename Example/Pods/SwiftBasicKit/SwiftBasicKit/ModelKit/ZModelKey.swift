import UIKit
import HandyJSON
import GRDB.Swift

/// 键值对
public class ZModelKey: ZModelBase {
    
    public class override var databaseTableName: String { "tb_key" }
    enum Columns: String, ColumnExpression {
        case key, value, isselect
    }
    public var key: String = ""
    public var value: String = ""
    public var isselect: Bool = false
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.key = model.key
        self.value = model.value
        self.isselect = model.isselect
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.key = row[Columns.key] ?? ""
        self.value = row[Columns.value] ?? ""
        self.isselect = row[Columns.isselect] ?? false
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.key] = self.key
        container[Columns.value] = self.value
        container[Columns.isselect] = self.isselect
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
