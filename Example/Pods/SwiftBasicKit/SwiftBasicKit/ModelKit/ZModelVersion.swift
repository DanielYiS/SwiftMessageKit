import UIKit
import HandyJSON
import GRDB.Swift

/// 数据库版本
public class ZModelVersion: ZModelBase {
    
    public class override var databaseTableName: String { "tb_version" }
    enum Columns: String, ColumnExpression {
        case version, content
    }
    public var version: Int = 0
    public var content: String = ""
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.version = model.version
        self.content = model.content
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.version = row[Columns.version] ?? 0
        self.content = row[Columns.content] ?? ""
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.version] = self.version
        container[Columns.content] = self.content
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
