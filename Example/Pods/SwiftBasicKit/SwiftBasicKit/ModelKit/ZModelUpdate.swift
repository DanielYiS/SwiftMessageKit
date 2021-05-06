import UIKit
import HandyJSON
import GRDB.Swift

public class ZModelUpdate: ZModelBase {
    
    public override class var databaseTableName: String { "tb_update" }
    enum Columns: String, ColumnExpression {
        case version, title, content, link, update, status, ignore
    }
    public var version: String = ""
    public var title: String = ""
    public var content: String = ""
    public var link: String = ""
    public var update: Bool = false
    public var status: Bool = false
    public var ignore: [String]?
    
    public required init() {
        super.init()
    }
    public required init<T>(instance: T) where T : ZModelBase {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.version = model.version
        self.title = model.title
        self.content = model.content
        self.link = model.link
        self.update = model.update
        self.status = model.status
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.version = row[Columns.version] ?? ""
        self.title = row[Columns.title] ?? ""
        self.content = row[Columns.content] ?? ""
        self.link = row[Columns.link] ?? ""
        self.update = row[Columns.update] ?? false
        self.status = row[Columns.status] ?? false
        self.ignore = (row[Columns.status] ?? "").components(separatedBy: "@")
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.version] = self.version
        container[Columns.title] = self.title
        container[Columns.content] = self.content
        container[Columns.link] = self.link
        container[Columns.update] = self.update
        container[Columns.status] = self.status
        container[Columns.ignore] = self.ignore?.joined(separator: "@") ?? ""
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.status <-- "maintain"
        mapper <<< self.title <-- "tips"
        mapper <<< self.content <-- "change_log"
        mapper <<< self.link <-- "link"
        mapper <<< self.update <-- "is_force"
    }
}
