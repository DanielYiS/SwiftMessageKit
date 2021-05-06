import UIKit
import HandyJSON
import GRDB.Swift

public class ZModelRoom: ZModelBase {
    
    public override class var databaseTableName: String { "tb_room" }
    enum Columns: String, ColumnExpression {
        case room_ownerid, room_name, room_type, room_time, room_video, room_audio, room_cover, video_time, audio_time, is_online, online_count, is_like, like_count, play_count, distance
    }
    public var room_user_login: ZModelUserLogin?
    public var room_ownerid: String = ""
    public var room_name: String = ""
    public var room_type: zRoomType = .video
    public var room_time: Double = Date().timeIntervalSince1970
    public var room_video: String = ""
    public var room_audio: String = ""
    public var room_cover: String = ""
    public var video_time: Int = 0
    public var audio_time: Int = 0
    public var is_online: Bool = true
    public var online_count: Int = 1
    public var is_like: Bool = false
    public var like_count: Int = 0
    public var play_count: Int = 0
    public var distance: Int = 0
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? Self else {
            return
        }
        if let user = model.room_user_login {
            self.room_user_login = ZModelUserLogin.init(instance: user)
        }
        self.room_ownerid = model.room_ownerid
        self.room_name = model.room_name
        self.room_type = model.room_type
        self.room_time = model.room_time
        self.room_video = model.room_video
        self.room_audio = model.room_audio
        self.room_cover = model.room_cover
        self.video_time = model.video_time
        self.audio_time = model.audio_time
        self.is_online = model.is_online
        self.online_count = model.online_count
        self.is_like = model.is_like
        self.like_count = model.like_count
        self.play_count = model.play_count
        self.distance = model.distance
    }
    public required init(row: Row) {
        super.init(row: row)
        
        self.room_user_login = ZModelUserLogin.init(row: row)
        self.room_ownerid = row[Columns.room_ownerid] ?? ""
        self.room_name = row[Columns.room_name] ?? ""
        self.room_type = row[Columns.room_type] ?? .video
        self.room_time = row[Columns.room_time] ?? 0
        self.room_video = row[Columns.room_video] ?? ""
        self.room_audio = row[Columns.room_audio] ?? ""
        self.room_cover = row[Columns.room_cover] ?? ""
        self.video_time = row[Columns.video_time] ?? 0
        self.audio_time = row[Columns.audio_time] ?? 0
        self.is_online = row[Columns.is_online] ?? true
        self.online_count = row[Columns.online_count] ?? 0
        self.is_like = row[Columns.is_like] ?? true
        self.like_count = row[Columns.like_count] ?? 0
        self.play_count = row[Columns.play_count] ?? 0
        self.distance = row[Columns.distance] ?? 0
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.room_ownerid] = self.room_ownerid
        container[Columns.room_name] = self.room_name
        container[Columns.room_type] = self.room_type
        container[Columns.room_time] = self.room_time
        container[Columns.room_video] = self.room_video
        container[Columns.room_audio] = self.room_audio
        container[Columns.room_cover] = self.room_cover
        container[Columns.video_time] = self.video_time
        container[Columns.audio_time] = self.audio_time
        container[Columns.is_online] = self.is_online
        container[Columns.online_count] = self.online_count
        container[Columns.is_like] = self.is_like
        container[Columns.like_count] = self.like_count
        container[Columns.play_count] = self.play_count
        container[Columns.distance] = self.distance
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}

