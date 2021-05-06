import UIKit
import HandyJSON
import GRDB.Swift

/// 定位对象
public class ZModelLocation: ZModelBase {
    
    public class override var databaseTableName: String { "tb_location" }
    enum Columns: String, ColumnExpression {
        case latitude, longitude, country, province, city, state, area, street, country_code, postal_code
    }
    /// 经度
    public var latitude: Double = 0
    /// 纬度
    public var longitude: Double = 0
    /// 国家
    public var country: String = ""
    /// 省
    public var province: String = ""
    /// 市
    public var city: String = ""
    /// 县
    public var state: String = ""
    /// 区
    public var area: String = ""
    /// 街道
    public var street: String = ""
    /// 国家code
    public var country_code: String = ""
    /// 邮政编码
    public var postal_code: String = ""
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        self.id = model.id
        self.latitude = model.latitude
        self.longitude = model.longitude
        self.country = model.country
        self.province = model.province
        self.city = model.city
        self.state = model.state
        self.street = model.street
        self.country_code = model.country_code
        self.postal_code = model.postal_code
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.latitude = row[Columns.latitude] ?? 0
        self.longitude = row[Columns.longitude] ?? 0
        self.country = row[Columns.country] ?? ""
        self.province = row[Columns.province] ?? ""
        self.city = row[Columns.city] ?? ""
        self.state = row[Columns.state] ?? ""
        self.area = row[Columns.area] ?? ""
        self.street = row[Columns.street] ?? ""
        self.country_code = row[Columns.country_code] ?? ""
        self.postal_code = row[Columns.postal_code] ?? ""
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.latitude] = self.latitude
        container[Columns.longitude] = self.longitude
        container[Columns.country] = self.country
        container[Columns.province] = self.province
        container[Columns.city] = self.city
        container[Columns.state] = self.state
        container[Columns.area] = self.area
        container[Columns.street] = self.street
        container[Columns.country_code] = self.country_code
        container[Columns.postal_code] = self.postal_code
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
