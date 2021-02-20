
import UIKit
import BFKit.Swift
import SwiftBasicKit.Swift
import ESPullToRefresh.Swift

public class ZMessageViewController: MessagesViewController {
    
    /// 发送者背景颜色
    public var currentBGColor: UIColor = UIColor.init(hex: "#F3A1BF")
    /// 接收者背景颜色
    public var receiveBGColor: UIColor = UIColor.init(hex: "#1E1925")
    /// 发送者文本颜色
    public var currentTextColor: UIColor = UIColor.black
    /// 接收者文本颜色
    public var receiveTextColor: UIColor = UIColor.white
    /// 返回图片
    public var imageBack: UIImage? = UIImage.bundledImage(named: "btn_back_black")
    /// 右侧按钮图片
    public var imageNavRight: UIImage? = UIImage.bundledImage(named: "message_video")
    /// 默认头像
    public var defaultAvatar: UIImage? = UIImage.bundledImage(named: "default_avatar")
    /// 语音按钮默认
    public var imageAudioNormal: UIImage? = UIImage.bundledImage(named: "message_voice")
    /// 语音按钮选中
    public var imageAudioSelect: UIImage? = UIImage.bundledImage(named: "message_voice2")
    /// 长按语音按钮默认
    public var imageAudioPressNormal: UIImage? = UIImage.bundledImage(named: "message_voice_n")
    /// 长按语音按钮按下
    public var imageAudioPressHighlighted: UIImage? = UIImage.bundledImage(named: "message_voice_h")
    /// 选择图片默认
    public var imagePhotoNormal: UIImage? = UIImage.bundledImage(named: "message_tools")
    /// 选择图片选中
    public var imagePhotoSelect: UIImage? = UIImage.bundledImage(named: "message_shut_down")
    /// 选择照片按钮
    public var imageAlbum: UIImage? = UIImage.bundledImage(named: "message_album")
    /// 选择相机按钮
    public var imageCamera: UIImage? = UIImage.bundledImage(named: "message_camera")
    /// 最小充值余额
    public var minRecharge: Double = 350
    
    /// 接受者用户对象
    private var modelUser: ZModelUserInfo?
    /// 当前登录用户
    var loginUser: ZModelMessageUser {
        let loginUser = ZSettingKit.shared.user ?? ZModelUserBase.init()
        let messageUser = ZModelMessageUser.init(senderId: loginUser.userid, displayName: loginUser.nickname, head: loginUser.avatar, role: loginUser.role.rawValue, gender: loginUser.gender.rawValue)
        return messageUser
    }
    /// 当前第几页
    private var page: Int = 1
    /// The `ZHYAudioPlayManager` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    lazy var audioPlayManager = AudioPlayManager(messageCollectionView: self.messagesCollectionView)
    /// 数据集合
    var messageList: [ZModelMessageType] = [ZModelMessageType]()
    /// 是否弹出了充值
    private var isShowRecharge: Bool = false
    /// 是否显示该页面
    private var isCurrentShowVC: Bool = false
    /// 当前参数
    private var viewParams: [String: Any]?
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    public static func initWithParams(params: [String: Any]?) -> UIViewController {
        let itemVC = Self.init()
        itemVC.viewParams = params
        return itemVC
    }
    
    /// 输入框左侧长按语音按钮
    private lazy var btnAudio: ZMessageButton = {
        let item = ZMessageButton.init(type: UIButton.ButtonType.custom)
        
        item.setImage(self.imageAudioNormal, for: UIControl.State.normal)
        item.setImage(self.imageAudioSelect, for: UIControl.State.selected)
        
        return item
    }()
    /// 输入框右侧选择图片按钮
    private lazy var btnImage: ZMessageButton = {
        let item = ZMessageButton.init(type: UIButton.ButtonType.custom)
        
        item.setImage(self.imagePhotoNormal, for: UIControl.State.normal)
        item.setImage(self.imagePhotoSelect, for: UIControl.State.selected)
        
        return item
    }()
    /// 语音长按按钮
    private lazy var btnAudioPress: ZMessageButton = {
        let item = ZMessageButton.init(type: UIButton.ButtonType.custom)
        
        item.border(color: UIColor.clear, radius: (10), width: 0)
        item.setBackgroundImage(self.imageAudioPressNormal, for: UIControl.State.normal)
        item.setBackgroundImage(self.imageAudioPressHighlighted, for: UIControl.State.highlighted)
        item.setTitle(L10n.messageAudioButtonText, for: UIControl.State.normal)
        item.setTitle(L10n.messageAudioButtonText, for: UIControl.State.highlighted)
        item.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        item.setTitleColor(.white, for: UIControl.State.normal)
        item.setTitleColor(.white, for: UIControl.State.highlighted)
        
        return item
    }()
    /// 选择图片
    private lazy var btnAlbum: ZMessageButton = {
        let item = ZMessageButton.init(type: UIButton.ButtonType.custom)
        
        item.setImage(self.imageAlbum, for: UIControl.State.normal)
        item.setImage(self.imageAlbum, for: UIControl.State.highlighted)
        item.imageEdgeInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
        
        return item
    }()
    /// 选择相机
    private lazy var btnCamera: ZMessageButton = {
        let item = ZMessageButton.init(type: UIButton.ButtonType.custom)
        
        item.setImage(self.imageCamera, for: UIControl.State.normal)
        item.setImage(self.imageCamera, for: UIControl.State.highlighted)
        item.imageEdgeInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
        
        return item
    }()
    /// 选择定位
    private lazy var btnLocation: ZMessageButton = {
        let item = ZMessageButton.init(type: UIButton.ButtonType.custom)
        
        item.setImage(UIImage.init(color: UIColor.white.withAlphaComponent(0)), for: UIControl.State.normal)
        item.setImage(UIImage.init(color: UIColor.white.withAlphaComponent(0)), for: UIControl.State.highlighted)
        item.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
        return item
    }()
    /// 占位符
    private lazy var btnPlaceholder: ZMessageButton = {
        let item = ZMessageButton.init(type: UIButton.ButtonType.custom)
        
        item.setImage(UIImage.init(color: UIColor.white.withAlphaComponent(0)), for: .normal)
        item.setImage(UIImage.init(color: UIColor.white.withAlphaComponent(0)), for: .highlighted)
        item.imageEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        
        return item
    }()
    /// 录制音频的View
    lazy var viewRecordAudio: ZMessageRecordAudioView = {
        let item = ZMessageRecordAudioView.init(frame: CGRect.init(x: ZKit.kScreenWidth/2 - ZKit.kFuncScale(150)/2, y: ZKit.kScreenHeight/2 - ZKit.kFuncScale(150)/2, width: ZKit.kFuncScale(150), height: ZKit.kFuncScale(150)))
        
        return item
    }()
    /// 顶部导航区域
    private lazy var viewTitle: ZMessageTitleView = {
        let item = ZMessageTitleView.init(frame: CGRect.init(x: 0, y: 0, width: ZKit.kScreenWidth, height: ZKit.kFullScreenY()))
        
        item.defaultAvatar = self.defaultAvatar
        
        return item
    }()
    /// 提示发送消息扣除费用
    private lazy var viewTipDiamond: ZMessageTipDiamondView = {
        let item = ZMessageTipDiamondView.init(frame: CGRect.init(x: ZKit.kFuncScale(15), y: ZKit.kFullScreenY(), width: ZKit.kScreenWidth - ZKit.kFuncScale(30), height: ZKit.kFuncScale(50)))
        
        item.isHidden = true
        item.alpha = 1
        
        return item
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.innerInitView()
        self.innerInitEvent()
        self.innerInitData()
        self.setNavBarBackBlack()
        if ZSettingKit.shared.role == .user && self.modelUser?.role != .customerService {
            self.navigationItem.rightBarButtonItem = nil
            
            let item = UIButton.init(type: UIButton.ButtonType.custom)
            
            item.isUserInteractionEnabled = true
            item.setImage(self.imageNavRight, for: UIControl.State.normal)
            item.setImage(self.imageNavRight, for: UIControl.State.highlighted)
            item.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 0)
            item.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            item.addTarget(self, action: #selector(btnNavBarRightClick), for: UIControl.Event.touchUpInside)
            item.frame = CGRect.init(x: 0, y: 0, width: 50, height: 45)
            
            let btnBackItem = UIBarButtonItem.init(customView: item)
            
            self.navigationItem.rightBarButtonItem = btnBackItem
        }
        ZCurrentVC.shared.currentPresentVC?.dismiss(animated: false, completion: nil)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isCurrentShowVC = true
        self.messageInputBar.setNeedsLayout()
        ZCurrentVC.shared.currentVC = self
        ZWebSocketApi.shared.isMultipleMessageViewShow = false
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        (self.navigationController as? ZNavigationController)?.shadowImage = UIImage.init(color: ZColor.shared.NavBarLineColor)?.withAlpha(0)
        (self.navigationController as? ZNavigationController)?.backgroundImage = UIImage.init(color: ZColor.shared.NavBarTintColor)?.withAlpha(0)
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.audioPlayManager.stopAnyOngoingPlaying()
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.isCurrentShowVC = false
        ZWebSocketApi.shared.isMultipleMessageViewShow = true
    }
    private func innerInitView() {
        if #available(iOS 11.0, *) {
            self.edgesForExtendedLayout = UIRectEdge.top
            self.viewRespectsSystemMinimumLayoutMargins = false
            self.messagesCollectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.messagesCollectionView.scrollsToTop = true
        self.messagesCollectionView.alwaysBounceVertical = true
        self.modalPresentationStyle = .fullScreen
        self.extendedLayoutIncludesOpaqueBars = false
        self.scrollsToBottomOnKeyboardBeginsEditing = true // default false
        self.maintainPositionOnKeyboardFrameChanged = true // default false
        self.messageInputBar.backgroundView.backgroundColor = UIColor.init(hex: "#EEEEEE")
        self.messageInputBar.bottomStackView.backgroundColor = UIColor.init(hex: "#FFFFFF")
        self.messageInputBar.inputTextView.backgroundColor = UIColor.init(hex: "#FFFFFF")
        self.messageInputBar.inputTextView.border(color: UIColor.clear, radius: (10), width: 0)
        self.messageInputBar.inputTextView.placeholderLabel.textColor = UIColor.init(hex: "#5C5A64")
        self.messageInputBar.inputTextView.placeholder = L10n.messageInputPlaceholder
        self.messageInputBar.inputTextView.returnKeyType = UIReturnKeyType.done
        self.messageInputBar.shouldManageSendButtonEnabledState = false
        self.messageInputBar.inputTextView.delegate = self
        //self.messageInputBar.delegate = self
        
        self.messageInputBar.setStackViewItems([self.btnAudio], forStack: InputStackView.Position.left, animated: false)
        self.messageInputBar.setStackViewItems([self.btnImage], forStack: InputStackView.Position.right, animated: false)
        
        self.messagesCollectionView.messagesDataSource = self
        self.messagesCollectionView.messageCellDelegate = self
        
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        
        self.messagesCollectionView.es.addPullToRefresh(handler: { [weak self] in
            self?.viewTipDiamond.alpha = 0
            self?.loadMoreMessages()
        })
        // 设置录音 delegate
        AudioRecordInstance.delegate = self
        self.registerReceivedNewMessageNotification()
        
        self.view.addSubview(self.viewTitle)
        self.view.addSubview(self.viewTipDiamond)
        self.view.addSubview(self.viewRecordAudio)
        self.view.bringSubviewToFront(self.viewTitle)
        self.view.bringSubviewToFront(self.viewTipDiamond)
        self.view.bringSubviewToFront(self.viewRecordAudio)
        self.view.sendSubviewToBack(self.messagesCollectionView)
    }
    deinit {
        AudioRecordInstance.delegate = nil
        self.messageInputBar.delegate = nil
        self.messageInputBar.inputTextView.delegate = nil
        self.messagesCollectionView.es.removeRefreshHeader()
        self.messagesCollectionView.messagesDataSource = nil
        self.messagesCollectionView.messageCellDelegate = nil
        self.messagesCollectionView.messagesLayoutDelegate = nil
        self.messagesCollectionView.messagesDisplayDelegate = nil
        self.removeReceivedNewMessageNotification()
    }
    @objc final func btnNavBarRightClick() {
        if ZSettingKit.shared.role == .user && self.modelUser?.role == .anchor {
            guard let model = self.modelUser else {
                return
            }
            ZProgressHUD.show(vc: self)
            // 发起视频呼叫 type = 1 普通呼叫 2 为hunting 呼叫
            var param = [String: Any]()
            param["callee_id"] = model.userid
            param["type"] = 1
            ZNetworkKit.shared().startRequest(ZNetworkTargetType.post(ZNetworkAction.call, param), responseBlock: { [weak self] result in
                ZProgressHUD.dismiss()
                if result.success, let dic = result.body as? [String: Any] {
                    BFLog.debug("send call success: \(dic)")
                } else if (result.code == ZNetworkCode.balance) {
                    NotificationCenter.default.post(name: Notification.Names.ShowRechargeReminderVC, object: self)
                } else {
                    ZProgressHUD.showMessage(self, result.message, .center)
                }
            })
        }
    }
    private func innerInitData() {
        if self.modelUser == nil, let user = self.viewParams?["user"] as? ZModelUserBase {
            self.setMessageUserInfo(user)
        }
        self.viewTipDiamond.isHidden = ZSettingKit.shared.role != .user
        self.messageList.removeAll()
        let sendid = String(self.modelUser?.id ?? 0)
        var models: [ZModelMessage]? = [ZModelMessage]()
        let array = ZSQLiteExecute.getArrayMessage(models: &models, userid: sendid)
        guard let arrayMessage = self.startConvertMessageModels(models) else {
            return
        }
        self.messageList.append(contentsOf: arrayMessage)
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
    }
    /// 下拉加载更多
    private func loadMoreMessages() {
        let lasttime = self.messageList.first?.sentTime ?? Date.init().timeIntervalSince1970
        if self.messageList.first == nil {
            self.messageList.removeAll()
        }
        let sendid = String(self.modelUser?.id ?? 0)
        var models: [ZModelMessage]? = [ZModelMessage]()
        let array = ZSQLiteExecute.getArrayMessage(models: &models, userid: sendid, time: lasttime)
        guard let arrayMessage = self.startConvertMessageModels(models) else {
            self.viewTipDiamond.alpha = self.viewTipDiamond.isHidden ? 0 : 1
            self.messagesCollectionView.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
            return
        }
        self.viewTipDiamond.alpha = self.viewTipDiamond.isHidden ? 0 : 1
        self.messageList.insert(contentsOf: arrayMessage, at: 0)
        self.messagesCollectionView.reloadDataAndKeepOffset()
        self.messagesCollectionView.es.stopPullToRefresh(ignoreDate: false, ignoreFooter: false)
    }
    /// 把数据集合的消息类型转换成试图需要的消息类型
    private func startConvertMessageModels(_ models: [ZModelMessage]?) -> [ZModelMessageType]? {
        let messages = models?.compactMap({ (model) -> ZModelMessageType? in
            return self.convertMessageModel(model)
        })
        return messages?.reversed()
    }
    /// 把消息对象转换成聊天记录对象
    private func convertMessageModel(_ model: ZModelMessage) -> ZModelMessageType? {
        let sendid: String = model.message_userid
        let nickname: String = self.modelUser?.nickname ?? ""
        let head: String = self.modelUser?.avatar ?? ""
        let role: Int = self.modelUser?.role.rawValue ?? 1
        let gender: Int = self.modelUser?.gender.rawValue ?? 1
        var sender: ZModelMessageUser?
        var receive: ZModelMessageUser?
        /// 消息是我发送的。 发送者是我自己
        if model.message_direction == .send {
            sender = self.loginUser
            receive = ZModelMessageUser.init(senderId: sendid, displayName: nickname, head: head, role: role, gender: gender)
        } else {
            sender = ZModelMessageUser.init(senderId: sendid, displayName: nickname, head: head, role: role, gender: gender)
            receive = self.loginUser
        }
        let messageId = model.message_id
        switch model.message_type {
        case .image:
            let fileUrl = URL.init(fileURLWithPath: model.message_file_path)
            let image = UIImage.init(contentsOfFile: model.message_file_path)
            var message = ZModelMessageType.init(image: image, imageUrl: fileUrl, sender: sender!, receive: receive!, messageId: messageId)
            message.sentTime = model.message_time
            message.sentDate = Date.init(timeIntervalSince1970: model.message_time)
            return message
        case .audio:
            let fileUrl = URL.init(fileURLWithPath: model.message_file_path)
            var message = ZModelMessageType.init(audioURL: fileUrl, sender: sender!, receive: receive!, messageId: messageId)
            message.sentTime = model.message_time
            message.sentDate = Date.init(timeIntervalSince1970: model.message_time)
            return message
        default:
            var message = ZModelMessageType.init(text: model.message, sender: sender!, receive: receive!, messageId: messageId)
            message.sentTime = model.message_time
            message.sentDate = Date.init(timeIntervalSince1970: model.message_time)
            return message
        }
    }
    /// 注册控件事件
    private func innerInitEvent() {
        self.btnAudio.addTarget(self, action: #selector(btnAudioClickEvent), for: UIControl.Event.touchUpInside)
        self.btnImage.addTarget(self, action: #selector(btnImageClickEvent), for: UIControl.Event.touchUpInside)
        
        self.btnAlbum.addTarget(self, action: #selector(btnAlbumClickEvent), for: UIControl.Event.touchUpInside)
        self.btnCamera.addTarget(self, action: #selector(btnCameraClickEvent), for: UIControl.Event.touchUpInside)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(btnViewTapEvent(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        /// 停止录音处理，可能是被动打断
        self.btnAudioPress.addTarget(self, action: #selector(btnAudioPressStopEvent(_:)), for: UIControl.Event.touchUpInside)
        /// 移出去表示取消语音
        self.btnAudioPress.addTarget(self, action: #selector(btnAudioPressCancelEvent(_:)), for: UIControl.Event.touchUpOutside)
        /// 按下去开始说话
        self.btnAudioPress.addTarget(self, action: #selector(btnAudioPressStartEvent(_:)), for: UIControl.Event.touchDown)
        /// 移动到内部 - 手指上滑，取消发送
        self.btnAudioPress.addTarget(self, action: #selector(btnAudioPressEnterEvent(_:)), for: UIControl.Event.touchDragEnter)
        /// 移动到外部 - 松开手指，取消发送
        self.btnAudioPress.addTarget(self, action: #selector(btnAudioPressExitEvent(_:)), for: UIControl.Event.touchDragExit)
    }
    /// 发送语音
    final func startSendAudio(_ uploadAmrData: Data, _ recordTime: Float, _ filepath: URL) {
        if self.isShowRecharge {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        // 判断如果是用户端需要检测用户的余额是否充足
        if self.checkRechargeAlertView() {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeReminderVC, object: self)
            return
        }
        BFLog.debug("start send audio fileUrl: \(filepath.path)")
        
        let receiveId = String(self.modelUser?.id ?? 0)
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role.rawValue ?? 1
        let receiveGender = self.modelUser?.gender.rawValue ?? 1
        let receiveUser = ZModelMessageUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole, gender: receiveGender)
        
        let messageid = ZKit.getRandomId()
        ZAgoraFileApi().uploadFile(filepath, receive: receiveUser, messageid: messageid)
        
        let message = ZModelMessageType.init(audioURL: filepath, sender: self.loginUser, receive: receiveUser, messageId: messageid)
        self.insertMessage(message)
    }
    /// 发送图片
    private func startSendImages(_ images: [UIImage]) {
        guard let image = images.first else {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        if self.isShowRecharge {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        // 判断如果是用户端需要检测用户的余额是否充足
        if self.checkRechargeAlertView() {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeReminderVC, object: self)
            return
        }
        let imageUrl = ZLocalFileApi.tempImagePath()
        ZLocalFileApi.saveImage(image, toPath: imageUrl)
        
        BFLog.debug("start send image imageUrl: \(imageUrl.path)")
        
        let receiveId = String(self.modelUser?.id ?? 0)
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role.rawValue ?? 1
        let receiveGender = self.modelUser?.gender.rawValue ?? 1
        let receiveUser = ZModelMessageUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole, gender: receiveGender)
        
        let messageid = ZKit.getRandomId()
        ZAgoraFileApi().uploadImage(imageUrl, receive: receiveUser, messageid: messageid)
        
        let message = ZModelMessageType.init(image: image, imageUrl: imageUrl, sender: self.loginUser, receive: receiveUser, messageId: messageid)
        self.insertMessage(message)
    }
    /// 发送文本
    private func startSendMessage(_ text: String) {
        // 文本内容不能为空
        guard text.length > 0 && text.length <= ZKey.number.messageMaxCount else {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        if self.isShowRecharge {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        // 判断如果是用户端需要检测用户的余额是否充足
        if self.checkRechargeAlertView() {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeReminderVC, object: self)
            return
        }
        BFLog.debug("start send message text: \(text)")
        
        let receiveId = String(self.modelUser?.id ?? 0)
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role.rawValue ?? 1
        let receiveGender = self.modelUser?.gender.rawValue ?? 1
        let receiveUser = ZModelMessageUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole, gender: receiveGender)
        
        let messageid = ZKit.getRandomId()
        ZAgoraMessageApi.shared.sendTextMessage(text, receive: receiveUser, messageid: messageid)
        
        let message = ZModelMessageType.init(text: text, sender: self.loginUser, receive: receiveUser, messageId: messageid)
        self.insertMessage(message)
        self.messageInputBar.inputTextView.text = ""
        self.messageInputBar.invalidatePlugins()
    }
    /// 收到新消息
    @objc func setReceivedNewMessage(_ sender: Notification) {
        guard let model = sender.object as? ZModelMessage else {
            return
        }
        model.message_user = self.modelUser
        guard let message = self.convertMessageModel(model) else {
            return
        }
        self.insertMessage(message)
        ZSQLiteExecute.setMessageUnRead(userid: model.message_userid)
    }
    /// 添加一条消息
    private func insertMessage(_ message: ZModelMessageType) {
        // 隐藏需要消费的提示框
        if !self.viewTipDiamond.isHidden && self.viewTipDiamond.alpha == 1 {
            self.viewTipDiamond.alpha = 0.99
            UIView.animate(withDuration: ZKey.number.animateTime, animations: {
                self.viewTipDiamond.alpha = 0
            }, completion: { end in
                self.viewTipDiamond.isHidden = true
            })
        }
        self.messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        self.messagesCollectionView.performBatchUpdates({
            self.messagesCollectionView.insertSections([self.messageList.count - 1])
            if self.messageList.count >= 2 {
                self.messagesCollectionView.reloadSections([self.messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    /// 处理滑动动画
    final func isLastSectionVisible() -> Bool {
        guard !self.messageList.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: self.messageList.count - 1)
        return self.messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    /// 聊天对象为用户，获取用户信息
    private func reloadOtherUserInfo() {
        let userid = self.modelUser?.userid ?? "0"
        var param = [String: Any]()
        param["user_id"] = userid
        ZNetworkKit.shared().startRequest(ZNetworkTargetType.get(ZNetworkAction.userDetail, param), responseBlock: { result in
            if result.success, let dic = result.body as? [String: Any] {
                self.modelUser = ZModelUserInfo.deserialize(from: dic)
                self.reloadViewData()
            }
        })
    }
    /// 聊天对象为主播，获取主播信息
    private func reloadAnchorInfo() {
        let anchorid = self.modelUser?.userid ?? "0"
        var param = [String: Any]()
        param["anchor_id"] = anchorid
        ZNetworkKit.shared().startRequest(ZNetworkTargetType.get(ZNetworkAction.anchorDetail, param), responseBlock: { result in
            if result.success, let dic = result.body as? [String: Any] {
                self.modelUser = ZModelUserInfo.deserialize(from: dic)
                self.reloadViewData()
            }
        })
    }
    /// 处理页面数据
    private func reloadViewData() {
        guard let model = self.modelUser else {
            return
        }
        self.viewTitle.setMessageTitleView(model: model)
    }
    /// 判断是否余额是否充足
    private func checkRechargeAlertView() -> Bool {
        let recipientRole = self.modelUser?.role ?? .user
        if ZSettingKit.shared.role == .user && ZSettingKit.shared.balance < self.minRecharge && recipientRole != .customerService {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return true
        }
        return false
    }
    /// 设置聊天对象的基本信息
    public final func setMessageUserInfo(_ model: ZModelUserBase) {
        self.modelUser = ZModelUserInfo.init(instance: model)
        switch model.role {
        case .user:
            self.reloadOtherUserInfo()
        case .anchor:
            self.reloadAnchorInfo()
        default:
            self.modelUser?.is_online = true
            self.modelUser?.is_busy = false
        }
        self.reloadViewData()
    }
    /// 监听键盘高度改变事件
    public func keyboardFrameChange(_ height: CGFloat) {
        BFLog.debug("keyboardFrameChange: \(height)")
    }
}
/// 文本输入框
extension ZMessageViewController: InputBarAccessoryViewDelegate, UITextViewDelegate {
    
    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        BFLog.debug("didPressSendButtonWith: \(text)")
        
        let attributedText = self.messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            BFLog.info("Autocompleted: \(substring)  with context: \(context ?? [])")
        }
        let components = inputBar.inputTextView.components
        self.messageInputBar.inputTextView.text = ""
        self.messageInputBar.invalidatePlugins()
        DispatchQueue.main.async { [weak self] in
            self?.insertMessages(components)
        }
    }
    public func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        BFLog.debug("textViewTextDidChangeTo: \(text)")
    }
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                self.startSendMessage(str)
            } else if let img = component as? UIImage {
                self.startSendImages([img])
            }
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.startSendMessage(textView.text)
            return false
        }
        let currentText = textView.text ?? ""
        var textLength = currentText.length + text.length
        if let inputRange = currentText.toRange(from: range) {
            let newText = currentText.replacingCharacters(in: inputRange, with: text)
            textLength = newText.length
        }
        if textLength > ZKey.number.messageMaxCount {
            return false
        }
        return true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.btnImage.isSelected {
            self.btnImage.isSelected = !self.btnImage.isSelected
            self.messageInputBar.setStackViewItems([], forStack: .bottom, animated: true)
            self.messageInputBar.setBottomStackViewHeightConstant(to: 0, animated: true)
        }
        return true
    }
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.length > ZKey.number.messageMaxCount {
            textView.text = textView.text.substring(to: ZKey.number.messageMaxCount)
        }
    }
}
/// 按钮事件
extension ZMessageViewController {
    /// 声音按钮切换
    @objc private func btnAudioClickEvent() {
        self.messageInputBar.inputTextView.resignFirstResponder()
        if self.isShowRecharge {
            return
        }
        self.btnAudio.isSelected = !self.btnAudio.isSelected
        if self.btnAudio.isSelected {
            self.messageInputBar.setRightStackViewWidthConstant(to: 0, animated: false)
            self.messageInputBar.setMiddleContentView(self.btnAudioPress, animated: false)
            self.messageInputBar.setStackViewItems([], forStack: .right, animated: false)
        } else {
            self.messageInputBar.setRightStackViewWidthConstant(to: 45, animated: false)
            self.messageInputBar.setMiddleContentView(self.messageInputBar.inputTextView, animated: false)
            self.messageInputBar.setStackViewItems([self.btnImage], forStack: .right, animated: false)
        }
    }
    /// 图片按钮切换
    @objc private func btnImageClickEvent() {
        self.messageInputBar.inputTextView.resignFirstResponder()
        if self.isShowRecharge {
            return
        }
        self.btnImage.isSelected = !self.btnImage.isSelected
        if self.btnImage.isSelected {
            self.messageInputBar.setStackViewItems([self.btnAlbum, self.btnCamera, self.btnLocation, self.btnPlaceholder], forStack: .bottom, animated: false)
            self.messageInputBar.setBottomStackViewHeightConstant(to: 55, animated: false)
        } else {
            self.messageInputBar.setStackViewItems([], forStack: .bottom, animated: false)
            self.messageInputBar.setBottomStackViewHeightConstant(to: 0, animated: false)
        }
    }
    /// 相册按钮切换
    @objc private func btnAlbumClickEvent() {
        if self.isShowRecharge {
            return
        }
        // 判断如果是用户端需要检测用户的余额是否充足
        if self.checkRechargeAlertView() {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeReminderVC, object: self)
            return
        }
        let itemVC = ZImagePickerController()
        
        itemVC.delegate = self
        itemVC.allowsEditing = false;
        itemVC.modalPresentationStyle = .fullScreen
        itemVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        ZRouterKit.present(animated: true, fromVC: self, toVC: itemVC)
    }
    /// 相机按钮切换
    @objc private func btnCameraClickEvent() {
        if self.isShowRecharge {
            return
        }
        // 判断如果是用户端需要检测用户的余额是否充足
        if self.checkRechargeAlertView() {
            NotificationCenter.default.post(name: Notification.Names.ShowRechargeReminderVC, object: self)
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let itemVC = ZImagePickerController()
            
            itemVC.delegate = self
            itemVC.allowsEditing = false
            itemVC.modalPresentationStyle = .fullScreen
            itemVC.sourceType = UIImagePickerController.SourceType.camera
            
            ZRouterKit.present(animated: true, fromVC: self, toVC: itemVC)
        } else {
            ZProgressHUD.showMessage(self, L10n.errorProfileCameraNotDevice)
        }
    }
    /// 按住语音开始录音按钮
    @objc private func btnAudioPressStartEvent(_ sender: UIButton) {
        if self.isShowRecharge {
            return
        }
        // 获取录音权限
        AudioRecordInstance.checkPermissionAndSetupRecord()
        BFLog.debug("start record audio")
        self.viewRecordAudio.startRecord()
        AudioRecordManager.sharedInstance.startRecord()
    }
    /// 录音完毕开始处理
    @objc private func btnAudioPressStopEvent(_ sender: UIButton) {
        if self.isShowRecharge {
            return
        }
        BFLog.debug("stop record audio")
        AudioRecordManager.sharedInstance.stopRecord()
    }
    /// 录音取消处理相关逻辑
    @objc private func btnAudioPressCancelEvent(_ sender: UIButton) {
        if self.isShowRecharge {
            return
        }
        BFLog.debug("cancel record audio")
        AudioRecordManager.sharedInstance.cancelRrcord()
    }
    /// 移动到内部 - 手指上滑，取消发送
    @objc private func btnAudioPressEnterEvent(_ sender: UIButton) {
        if self.isShowRecharge {
            return
        }
        BFLog.debug("enter record audio")
        self.viewRecordAudio.recording()
    }
    /// 移动到外部 - 松开手指，取消发送
    @objc private func btnAudioPressExitEvent(_ sender: UIButton) {
        if self.isShowRecharge {
            return
        }
        BFLog.debug("exit record audio")
        self.viewRecordAudio.slideToCancelRecord()
    }
    /// 点击屏幕收起键盘
    @objc private func btnViewTapEvent(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        self.view.endEditing(true)
    }
}
/// 处理相机
extension ZMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.startSendImages([image])
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
