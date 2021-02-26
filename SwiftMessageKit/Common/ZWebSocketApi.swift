
import UIKit
import BFKit
import HandyJSON
import Starscream
import SwiftBasicKit

/// 消息管理类
public class ZWebSocketApi: NSObject {
    
    /// 时间回调
    public var onTimerBlock: ( () -> Void)?
    /// 连接编码
    public var clientId: String = ""
    /// 是否显示消息通知页面
    public var isMultipleMessageViewShow: Bool = false
    /// 单例模式
    public static let shared = ZWebSocketApi()
    /// 连接状态
    private var isConnected: Bool = false
    /// IM聊天
    private var webSocket: WebSocket?
    /// 心跳定时器
    private var pingTimer: Timer?
    /// 保持心跳频率
    private var pingTime: TimeInterval = 20
    /// 开始连接
    public func reconnect() {
        if self.isConnected || !ZSettingKit.shared.isLogin {
            return
        }
        self.disconnect()
        let url = URL.init(string: ZKey.service.wss)!
        var request = URLRequest.init(url: url)
        request.timeoutInterval = ZKey.number.messageReconnectTime
        //request.setValue("14", forHTTPHeaderField: "Sec-WebSocket-Version")
        request.setValue(ZSettingKit.shared.userId, forHTTPHeaderField: "uid")
        request.setValue(ZSettingKit.shared.token, forHTTPHeaderField: "Authorization")
        self.webSocket = WebSocket.init(request: request)
        self.webSocket?.delegate = self
        self.webSocket?.connect()
        self.startTimer()
        BFLog.debug("webim reconnect")
    }
    /// 断开连接
    public func disconnect() {
        self.stopTimer()
        self.webSocket?.disconnect()
        self.webSocket?.delegate = nil
        self.webSocket = nil
        self.isConnected = false
        BFLog.debug("webim disconnect")
    }
    /// 开启心跳定时器
    private func startTimer() {
        if self.pingTimer == nil {
            self.pingTimer = Timer.scheduledTimer(timeInterval: self.pingTime, target: self, selector: #selector(self.executeTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(self.pingTimer!, forMode: RunLoop.Mode.common)
        }
    }
    /// 停止心跳定时器
    private func stopTimer() {
        self.pingTimer?.invalidate()
        self.pingTimer = nil
    }
    /// 执行心跳定时器
    @objc private func executeTimer() {
        self.onTimerBlock?()
        self.sendMessage()
    }
    /// 发送消息
    public func sendMessage(text: String) {
        self.reconnect()
        self.webSocket?.write(string: text, completion: {
            BFLog.debug("message send success")
        })
    }
    /// 默认文本
    private func sendMessage() {
        self.reconnect()
        self.webSocket?.write(string: "M", completion: {
            BFLog.debug("message send success")
        })
    }
}
/// MARK: - WebSocketDelegate
extension ZWebSocketApi: WebSocketDelegate {
    
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            self.isConnected = true
            BFLog.debug("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            self.isConnected = false
            BFLog.debug("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            BFLog.debug("websocket Received text: \(text)")
            NotificationCenter.default.post(name: Notification.Names.ReceivedEventMessage, object: text)
        case .viabilityChanged(_):
            self.isConnected = false
        case .reconnectSuggested(_):
            break
        case .cancelled:
            self.isConnected = false
        case .error(let error):
            self.isConnected = false
            BFLog.debug("websocket error: \(error?.localizedDescription ?? "")")
        default: break
        }
    }
}
