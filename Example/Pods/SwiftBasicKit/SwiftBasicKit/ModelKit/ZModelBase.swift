import UIKit
import HandyJSON
import GRDB.Swift

public protocol ZModelCopyable {
    
    init(instance: Self)
}
extension ZModelCopyable {
    public func copyable() -> Self {
        return Self.init(instance: self)
    }
}
private let kZGRDBReferenceRowKey: String = "referenceRow"
open class ZModelBase: Record, HandyJSON, ZModelCopyable {
    
    public enum Columns: String, ColumnExpression {
        case id
    }
    public var id: Int64 = 0
    public var rawData: [String: Any]?
    
    public required override init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init()
        
        self.id = instance.id
        self.rawData = instance.rawData
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.id = row[ZModelBase.Columns.id] ?? 0
    }
    public override func didInsert(with rowID: Int64, for column: String?) {
        super.didInsert(with: rowID, for: column)
        
        self.id = rowID
    }
    open override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
    }
    open func mapping(mapper: HelpingMapper) {
        
        mapper <<< self.id <-- "id"
    }
    public func toDictionary() -> [String: Any]? {
        var dic = self.toJSON()
        dic?.removeValue(forKey: kZGRDBReferenceRowKey)
        return dic
    }
}
