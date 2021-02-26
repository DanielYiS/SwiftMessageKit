import UIKit
import HandyJSON
import GRDB.Swift

public class ZModelUserBase: ZModelBase {
    
    public class override var databaseTableName: String { "tb_user" }
    public enum Columns: String, ColumnExpression {
        case token, userid, password, role, nickname, gender, avatar, age, birthday, height, weight, bodytype, belong, country, province, city, email, tel, introduction, balance, photos, videos, show_location
    }
    public var token: String = ""
    public var password: String = ""
    public var userid: String = ""
    public var nickname: String = ""
    public var role: zUserRole = .user
    public var gender: zUserGender = .none
    public var avatar: String = ""
    public var age: Int = 0
    public var birthday: String = ""
    public var height: Int = 0
    public var weight: Int = 0
    public var bodytype: String = ""
    public var belong: String = ""
    public var country: String = ""
    public var province: String = ""
    public var city: String = ""
    public var email: String = ""
    public var tel: String = ""
    public var introduction: String = ""
    public var balance: Double = 0
    public var photos: [String]?
    public var videos: [String]?
    public var show_location: Bool = true
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? ZModelUserBase else {
            return
        }
        self.token = model.token
        self.password = model.password
        self.userid = model.userid
        self.nickname = model.nickname
        self.role = model.role
        self.gender = model.gender
        self.avatar = model.avatar
        self.age = model.age
        self.birthday = model.birthday
        self.height = model.height
        self.weight = model.weight
        self.bodytype = model.bodytype
        self.belong = model.belong
        self.country = model.country
        self.province = model.province
        self.city = model.city
        self.email = model.email
        self.tel = model.tel
        self.introduction = model.introduction
        self.balance = model.balance
        self.photos = model.photos
        self.videos = model.videos
        self.show_location = model.show_location
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.token = row[Columns.token] ?? ""
        self.userid = row[Columns.userid] ?? ""
        self.password = row[Columns.password] ?? ""
        self.nickname = row[Columns.nickname] ?? ""
        self.role = row[Columns.role] ?? .user
        self.gender = row[Columns.gender] ?? .none
        self.avatar = row[Columns.avatar] ?? ""
        self.age = row[Columns.age] ?? 0
        self.birthday = row[Columns.birthday] ?? ""
        self.height = row[Columns.height] ?? 0
        self.weight = row[Columns.weight] ?? 0
        self.bodytype = row[Columns.bodytype] ?? ""
        self.belong = row[Columns.belong] ?? ""
        self.country = row[Columns.country] ?? ""
        self.province = row[Columns.province] ?? ""
        self.city = row[Columns.city] ?? ""
        self.email = row[Columns.email] ?? ""
        self.tel = row[Columns.tel] ?? ""
        self.introduction = row[Columns.introduction] ?? ""
        self.balance = row[Columns.balance] ?? 0
        self.photos = (row[Columns.photos] as? String)?.split(separator: ",").compactMap({ (item) -> String in
            return "\(item)"
        })
        self.videos = (row[Columns.videos] as? String)?.split(separator: ",").compactMap({ (item) -> String in
            return "\(item)"
        })
        self.show_location = row[Columns.show_location] ?? true
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.token] = self.token
        container[Columns.userid] = self.userid
        container[Columns.password] = self.password
        container[Columns.nickname] = self.nickname
        container[Columns.role] = self.role
        container[Columns.gender] = self.gender
        container[Columns.avatar] = self.avatar
        container[Columns.age] = self.age
        container[Columns.birthday] = self.birthday
        container[Columns.height] = self.height
        container[Columns.weight] = self.weight
        container[Columns.bodytype] = self.bodytype
        container[Columns.belong] = self.belong
        container[Columns.country] = self.country
        container[Columns.province] = self.province
        container[Columns.city] = self.city
        container[Columns.email] = self.email
        container[Columns.tel] = self.tel
        container[Columns.introduction] = self.introduction
        container[Columns.balance] = self.balance
        if let photos = self.photos?.joined(separator: ",") {
            container[Columns.photos] = photos
        }
        if let videos = self.videos?.joined(separator: ",") {
            container[Columns.videos] = videos
        }
        container[Columns.show_location] = self.show_location
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
