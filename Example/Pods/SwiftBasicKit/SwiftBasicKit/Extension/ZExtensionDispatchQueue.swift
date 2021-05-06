import UIKit
import BFKit

extension DispatchQueue {
    /// GCD延时操作
    ///   - after: 延迟的时间
    ///   - handler: 事件
    public static func DispatchAfter(after: Double, handler: @escaping ()->(Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            handler()
        }
    }
    /// GCD异步操作
    ///   - globalHandler: 子线程事件
    ///   - mainHandler: 主线程事件
    public static func DispatchaSync(globalHandler: @escaping ()->(Void), mainHandler: @escaping ()->(Void)) {
        DispatchQueue.global().async(execute: {
            globalHandler()
            DispatchQueue.main.async(execute: {
                mainHandler()
            })
        })
    }
    /// GCD异步操作
    ///   - mainHandler: 主线程事件
    public static func DispatchaSync(mainHandler: @escaping ()->(Void)) {
        if Thread.isMainThread {
            mainHandler()
        } else {
            DispatchQueue.main.sync {
                mainHandler()
            }
        }
    }
    /// GCD定时器循环操作
    ///   - timeInterval: 循环间隔时间
    ///   - handler: 循环事件
    public static func DispatchTimer(timeInterval: Double, handler: @escaping (DispatchSourceTimer?)->(Void)) {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: timeInterval)
        timer.setEventHandler {
            DispatchQueue.main.async {
                handler(timer)
            }
        }
        timer.resume()
    }
    /// GCD定时器倒计时
    ///   - timeInterval: 循环间隔时间
    ///   - repeatCount: 重复次数
    ///   - handler: 循环事件, 闭包参数： 1. timer， 2. 剩余执行次数
    public static func DispatchTimer(timeInterval: Double, repeatCount:Int, handler: @escaping (DispatchSourceTimer?, Int)->(Void)) {
        if repeatCount <= 0 {
            return
        }
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        var count = repeatCount
        timer.schedule(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
            }
        })
        timer.resume()
    }
}
