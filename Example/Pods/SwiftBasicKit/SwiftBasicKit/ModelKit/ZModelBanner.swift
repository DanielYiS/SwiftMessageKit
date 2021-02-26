import UIKit
import HandyJSON
import GRDB.Swift

public class ZModelBanner: ZModelBase {
    
    public class override var databaseTableName: String { "tb_banner" }
    enum Columns: String, ColumnExpression {
        case title, type, path, image
    }
    public var title: String = ""
    public var type: String = ""
    public var path: String = ""
    public var image: String = ""
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.title = model.title
        self.type = model.type
        self.path = model.path
        self.image = model.image
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.title = row[Columns.title] ?? ""
        self.type = row[Columns.type] ?? ""
        self.path = row[Columns.path] ?? ""
        self.image = row[Columns.image] ?? ""
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.title] = self.title
        container[Columns.type] = self.type
        container[Columns.path] = self.path
        container[Columns.image] = self.image
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
