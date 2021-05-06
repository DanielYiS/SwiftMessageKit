import UIKit
import HandyJSON
import GRDB.Swift

public class ZModelUserInfo: ZModelUserBase {
    
    /// 是否在线
    public var is_online: Bool = false
    /// 是否忙
    public var is_busy: Bool = false
    /// 是否热门
    public var is_hot: Bool = false
    /// 是否最新
    public var is_new: Bool = false
    /// 未读数量
    public var unReadCount: Int = 0
    /// 关注数量
    public var attcount: Int = 0
    /// 是否关注
    public var is_following: Bool = false
    /// 是否喜欢
    public var is_like: Bool = false
    /// 是否拉黑
    public var is_block: Bool = false
    /// 关注时间
    public var followed_at: Double = 0
    /// 拉黑时间
    public var blocked_at: Double = 0
    /// 关注数量
    public var follower_count: Int = 0
    /// 当前收入
    public var income: Int = 0
    /// 主播价格 - 每分钟消费多少金币
    public var price: Int = 0
    /// 消费金额
    public var consumption: Int = 0
    /// 主播标签
    public var tags: [ZModelTag]?
    /// 排行分
    public var score: Int = 0
    /// 亲密榜对象
    public var rank_other_people: ZModelUserInfo?
    /// 排行榜
    public var ranks: [ZModelUserInfo]?
    /// 点赞数量
    public var comment_like_count: Int = 0
    /// 踩数量
    public var comment_nope_count: Int = 0
    /// 评级分数
    public var comment_rating: Double = 0
    /// 今日收益
    public var today_earnings: Int = 0
    /// 昨日收益
    public var yesterday_earnings: Int = 0
    /// 当前等级
    public var level: Int = 0
    /// 通话时长
    public var call_duration: Int = 0
    /// 属性
    public var attrs: [String: Any]?
    /// 主播
    public var anchor: [String: Any]?
    /// 测试方案
    public var test: [String: Any]?
    /// 活动对象
    public var activity: [String: Any]?
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? ZModelUserInfo else {
            return
        }
        self.is_online = model.is_online
        self.is_busy = model.is_busy
        self.is_hot = model.is_hot
        self.is_new = model.is_new
        self.unReadCount = model.unReadCount
        self.attcount = model.attcount
        self.is_following = model.is_following
        self.is_like = model.is_like
        self.is_block = model.is_block
        self.followed_at = model.followed_at
        self.blocked_at = model.blocked_at
        self.follower_count = model.follower_count
        self.income = model.income
        self.price = model.price
        self.consumption = model.consumption
        if let array = model.tags {
            var arraytag = [ZModelTag]()
            array.forEach { (tag) in
                arraytag.append(ZModelTag.init(instance: tag))
            }
            self.tags = arraytag
        }
        self.score = model.score
        if let other_people = model.rank_other_people {
            self.rank_other_people = ZModelUserInfo.init(instance: other_people)
        }
        if let array = model.ranks {
            var arrayrank = [ZModelUserInfo]()
            array.forEach { (tag) in
                arrayrank.append(ZModelUserInfo.init(instance: tag))
            }
            self.ranks = arrayrank
        }
        self.comment_like_count = model.comment_like_count
        self.comment_nope_count = model.comment_nope_count
        self.comment_rating = model.comment_rating
        self.today_earnings = model.today_earnings
        self.yesterday_earnings = model.yesterday_earnings
        self.level = model.level
        self.call_duration = model.call_duration
        self.test = model.test
        self.activity = model.activity
    }
    public required init(row: Row) {
        super.init(row: row)
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.rank_other_people <-- "other_people"
        mapper <<< self.is_hot <-- "anchor.is_hot"
        mapper <<< self.is_new <-- "anchor.is_new"
        mapper <<< self.price <-- "anchor.price"
        mapper <<< self.consumption <-- "token"
        mapper <<< self.tags <-- "anchor.tags"
        mapper <<< self.comment_like_count <-- "anchor.comment.nice_count"
        mapper <<< self.comment_nope_count <-- "anchor.comment.nope_count"
        mapper <<< self.comment_rating <-- "anchor.comment.rating"
    }
}
