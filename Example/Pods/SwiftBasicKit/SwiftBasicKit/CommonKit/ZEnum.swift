
import HandyJSON
import GRDB.Swift

/// app状态类型
public enum zAppStatus: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 无
    case none = 0
    /// 开发中
    case dev = 1
    /// 发布中
    case release = 2
    /// 运营中
    case prod = 3
}
/// 文件类型
public enum zFileType: String {
    /// 图片
    case png = "png"
    /// 图片
    case jpeg = "jpeg"
    /// 音频
    case mp3 = "mp3"
    /// 视频
    case mp4 = "mp4"
    /// 视频
    case wav = "wav"
}
/// 性别枚举
public enum zUserGender: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 默认
    case none = 0
    /// 男
    case male = 1
    /// 女
    case female = 2
}
/// 用户角色
public enum zUserRole: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 游客
    case guest = 0
    /// 用户
    case user = 1
    /// 主播
    case anchor = 2
    /// 客服
    case customerService = 9
}
/// 用户行为类型
public enum zUserBehaviorType: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 无
    case none = 0
    /// 关注
    case follow = 1
    /// 喜欢
    case like = 2
    /// 拉黑
    case black = 3
    /// 收藏
    case collect = 4
    /// 删除
    case delete = 5
}
/// 消息类型
public enum zMessageType: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 文本
    case text = 0
    /// 图片
    case image = 1
    /// 音频文件
    case audio = 2
    /// 呼叫
    case call = 3
    /// 视频
    case video = 4
    /// 定位
    case location = 5
    /// 系统消息
    case system = 9
}
/// 消息方向
public enum zMessageDirection: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 接收
    case receive = 1
    /// 发送
    case send = 2
}
/// 房间类型
public enum zRoomType: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 短视频
    case video = 1
    /// 直播
    case live = 2
    /// 游戏
    case game = 3
    /// pk
    case pk = 4
    /// 聊天室
    case chat = 5
    /// 语音
    case voice = 6
}
