import UIKit
import HandyJSON
import GRDB.Swift

/// 标签
public class ZModelTag: ZModelBase {
    
    public class override var databaseTableName: String { "tb_tag" }
    enum Columns: String, ColumnExpression {
        case tagid, tagname, textcolor, bgcolor
    }
    public var tagid: String = ""
    public var tagname: String = ""
    public var bgcolor: String = ""
    public var textcolor: String = ""
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.tagid = model.tagid
        self.tagname = model.tagname
        self.bgcolor = model.bgcolor
        self.textcolor = model.textcolor
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.tagid = row[Columns.tagid] ?? ""
        self.tagname = row[Columns.tagname] ?? ""
        self.bgcolor = row[Columns.bgcolor] ?? ""
        self.textcolor = row[Columns.textcolor] ?? ""
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.tagid] = self.tagid
        container[Columns.tagname] = self.tagname
        container[Columns.bgcolor] = self.bgcolor
        container[Columns.textcolor] = self.textcolor
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.tagid <-- "id"
        mapper <<< self.tagname <-- "name"
        mapper <<< self.textcolor <-- "style.color"
        mapper <<< self.bgcolor <-- "style.background_color"
    }
}
