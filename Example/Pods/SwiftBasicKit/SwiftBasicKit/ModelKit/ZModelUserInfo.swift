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
    public var is_att: Bool = false
    /// 是否喜欢
    public var is_like: Bool = false
    /// 是否拉黑
    public var is_block: Bool = false
    /// 当前收入
    public var income: Int = 0
    /// 主播价格 - 每分钟消费多少金币
    public var price: Int = 0
    /// 消费金额
    public var consumption: Int = 0
    /// 主播标签
    public var tags: [ZModelTag]?
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
    /// 首充方案 A 0.99 B 4.99
    public var test_first_recharge: String = "A"
    /// 是否有资格参加首次充值
    public var activity_first_recharge: Bool = false
    /// 免费通话资格
    public var activity_free_call: Bool = false
    /// 新用户领取礼包 1 可以领取
    public var activity_new_user_draw_token: Bool = false
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
    }
    public required init(row: Row) {
        super.init(row: row)
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
        mapper <<< self.userid <-- "id"
        mapper <<< self.token <-- "api_token"
        mapper <<< self.consumption <-- "token"
        mapper <<< self.nickname <-- "profile.nickname"
        mapper <<< self.gender <-- "profile.gender"
        mapper <<< self.age <-- "profile.age"
        mapper <<< self.avatar <-- "profile.head"
        mapper <<< self.introduction <-- "profile.mood"
        mapper <<< self.country <-- "profile.country"
        mapper <<< self.province <-- "profile.province"
        mapper <<< self.city <-- "profile.city"
        mapper <<< self.comment_like_count <-- "comment.nice_count"
        mapper <<< self.comment_nope_count <-- "comment.nope_count"
        mapper <<< self.comment_rating <-- "comment.rating"
        mapper <<< self.test_first_recharge <-- "test.first_recharge"
        mapper <<< self.activity_first_recharge <-- "activity.first_recharge"
        mapper <<< self.activity_free_call <-- "activity.free_call"
        mapper <<< self.activity_new_user_draw_token <-- "activity.new_user_draw_token"
    }
}
