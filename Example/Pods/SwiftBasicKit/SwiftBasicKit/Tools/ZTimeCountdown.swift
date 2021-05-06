
import UIKit

/// 时间倒计时
fileprivate struct ZTimeCountdownEndDate {
    var day: Int?
    var hour: Int?
    var minute: Int?
    var second: Int?
}
/// 时间倒计时
public class ZTimeCountdown: NSObject {
    /// 要计算的时间
    private var currentDate: ZTimeCountdownEndDate?
    /// 定时器 GCD
    private var timer: DispatchSourceTimer?
    /// 开始时间
    private var startDateString: String? = nil
    /// 结束时间
    private var endDateString: String? = nil
    /// 回调 计算好的 天、时、分、秒
    public var onZTimeCountdownBlock: ((_ day: String, _ hour: String, _ minute: String, _ second: String) -> Void)?
    /// 开始启动定时器，需传入结束时间
    public final func start(with startDate: String?, end endDate: String) { startDateString = startDate ; endDateString = endDate ; createTimer() }
    /// 启用定时器
    public final func resume() { if endDateString == nil { return } ; createTimer() }
    /// 暂停定时器
    public final func suspend() { stop() }
    /// 停止定时器
    public final func stop() {
        if self.timer != nil {
            self.timer?.cancel()
            self.timer = nil
        }
    }
    /// 创建定时器
    private func createTimer() {
        guard let endDateString = endDateString else { return }
        guard let countDown = onZTimeCountdownBlock else { return }
        // 将 endDateString 转化成时间戳
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ZKey.timeFormat.yyyyMMddHHmmss
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        guard let endDate = dateFormatter.date(from: endDateString) else { return }
        let startDate: Date
        if let startDateString = startDateString { startDate = dateFormatter.date(from: startDateString)! }
        else { startDate = Date() }
        var timeCount = endDate.timeIntervalSince(startDate)
        // 当时间小于当前时间
        if timeCount <= 0 { countDown("00", "00", "00", "00") ; return }
        // 设置计算时间的格式
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let component = calendar.dateComponents(unit, from: Date(), to: endDate)
        currentDate = ZTimeCountdownEndDate(day: component.day, hour: component.hour, minute: component.minute, second: component.second)
        // 设置定时器
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
            timer!.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1))
            // 定时器的回调事件
            timer!.setEventHandler { [unowned self] in self.calculateCurrentDate() ; timeCount -= 1 }
            timer!.resume()
        }
    }
    /// 定时器计时事件
    private func calculateCurrentDate() {
        guard let _ = currentDate else { return }
        guard let countDown = onZTimeCountdownBlock else { return }
        // 计算显示时间
        currentDate!.second! -= 1
        if currentDate!.second! == -1 { currentDate!.second! = 59 ; currentDate!.minute! -= 1
            if currentDate!.minute! == -1 { currentDate!.minute! = 59 ; currentDate!.hour! -= 1
                if currentDate!.hour! == -1 { currentDate!.hour! = 23 ; currentDate!.day! -= 1 }
            }
        }
        if  currentDate!.second! == 0
                &&  currentDate!.minute! == 0
                && currentDate!.hour! == 0
                && currentDate!.day! == 0 {
            timer!.cancel()
            DispatchQueue.main.async(execute: { countDown("0", "00", "00", "00") })
            return
        }
        // 主线程更新返回数据
        DispatchQueue.main.async(execute: { [unowned self ] in
            countDown(String(format: "%02d", self.currentDate!.day!),
                      String(format: "%02d", self.currentDate!.hour!),
                      String(format: "%02d", self.currentDate!.minute!),
                      String(format: "%02d", self.currentDate!.second!))
        })
    }
    deinit {
        timer?.cancel()
        timer = nil
    }
}
