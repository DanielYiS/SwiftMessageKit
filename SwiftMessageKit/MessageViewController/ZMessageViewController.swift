
import UIKit
import BFKit
import SwiftBasicKit
import ESPullToRefresh

open class ZMessageViewController: MessagesViewController {
    
    /// 发送者背景颜色
    public var currentBGColor: UIColor = UIColor.init(hex: "#8100DC")
    /// 接收者背景颜色
    public var receiveBGColor: UIColor = UIColor.init(hex: "#00C907")
    /// 发送者文本颜色
    public var currentTextColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// 接收者文本颜色
    public var receiveTextColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// 发送按钮背景颜色
    public var buttonSendBGColor: UIColor = UIColor.init(hex: "#8100DC")
    /// 返回图片
    public var imageBack: UIImage? = UIImage.messageImage(type: .back)
    /// 发送按钮
    public var imageSend: UIImage? = UIImage.messageImage(type: .send)
    /// 背景颜色
    public var imageBG: UIImage? = UIImage.init(color: UIColor.init(hex: "#FFFFFF"))
    /// 导航栏右侧图片
    public var imageRight: UIImage? = UIImage.messageImage(type: .report)
    /// 输入区域背景颜色
    public var inputBarBGColor: UIColor = UIColor.init(hex: "#8100DC")
    /// 输入框背景颜色
    public var inputViewBGColor: UIColor = UIColor.init(hex: "#FFFFFF")
    /// 输入框边框弧度
    public var inputViewBorderRadius: CGFloat = 3
    /// 输入框提示文本颜色
    public var inputPlaceholderColor: UIColor = UIColor.init(hex: "#C3C3C3")
    /// 输入框文本颜色
    public var inputTextColor: UIColor = UIColor.init(hex: "#000000")
    /// 当前登录用户
    public var loginUser: ZModelMessageUser {
        let loginUser = ZSettingKit.shared.userLogin ?? ZModelUserLogin.init()
        let messageUser = ZModelMessageUser.init(senderId: loginUser.userid, displayName: loginUser.nickname, head: loginUser.avatar, role: loginUser.role.rawValue, gender: loginUser.gender.rawValue)
        return messageUser
    }
    private let maxMessageCount: Int = 140
    /// 接受者用户对象
    public var modelUser: ZModelUserLogin? {
        didSet {
            self.title = self.modelUser?.nickname
        }
    }
    /// 数据集合
    public var arrayMessage: [ZModelMessageType] = [ZModelMessageType]()
    /// 是否显示该页面
    public var isCurrentShowVC: Bool = false
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    private lazy var imageViewBG: UIImageView = {
        let z_item_image = UIImageView.init(frame: self.view.bounds)
        z_item_image.image = self.imageBG
        return z_item_image
    }()
    private lazy var btnSend: ZMessageButton = {
        let z_item_btn = ZMessageButton.init(type: .custom)
        z_item_btn.titleLabel?.boldSize = 15
        z_item_btn.adjustsImageWhenHighlighted = false
        z_item_btn.setImage(self.imageSend, for: .normal)
        z_item_btn.backgroundColor = self.buttonSendBGColor
        z_item_btn.frame = CGRect.init(x: 0, y: 0, width: 55, height: 42)
        z_item_btn.border(color: .clear, radius: 2, width: 0)
        z_item_btn.imageEdgeInsets = UIEdgeInsets.init(top: 2, left: 2, bottom: 2, right: 2)
        return z_item_btn
    }()
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.innerInitView()
        self.innerInitEvent()
        self.innerInitData(true)
        self.setNavBarBackBlack()
        self.setNavBarRightButton(image: self.imageRight)
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isCurrentShowVC = true
        ZCurrentVC.shared.currentVC = self
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.isCurrentShowVC = false
    }
    private func innerInitView() {
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        if #available(iOS 11.0, *) {
            self.edgesForExtendedLayout = UIRectEdge.top
            self.viewRespectsSystemMinimumLayoutMargins = false
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.modalPresentationStyle = .fullScreen
        self.extendedLayoutIncludesOpaqueBars = false
        self.view.isUserInteractionEnabled = true
        
        self.messageInputBar.backgroundView.backgroundColor = self.inputBarBGColor
        self.messageInputBar.bottomStackView.backgroundColor = self.inputBarBGColor
        self.messageInputBar.inputTextView.backgroundColor = self.inputViewBGColor
        self.messageInputBar.inputTextView.border(color: UIColor.clear, radius: inputViewBorderRadius, width: 0)
        self.messageInputBar.inputTextView.placeholderLabel.textColor = self.inputPlaceholderColor
        self.messageInputBar.inputTextView.placeholder = L10n.inputMessagePlaceholder
        self.messageInputBar.inputTextView.textColor = self.inputTextColor
        self.messageInputBar.inputTextView.returnKeyType = UIReturnKeyType.send
        self.messageInputBar.inputTextView.delegate = self
        self.messageInputBar.setLeftStackViewWidthConstant(to: 0, animated: false)
        self.messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        self.messageInputBar.setStackViewItems([self.btnSend], forStack: InputStackView.Position.right, animated: false)
        
        self.messagesCollectionView.backgroundColor = .clear
        self.messagesCollectionView.messagesDataSource = self
        self.messagesCollectionView.messageCellDelegate = self
        
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        
        self.scrollsToBottomOnKeyboardBeginsEditing = true // default false
        self.maintainPositionOnKeyboardFrameChanged = true // default false
        self.view.addSubview(self.imageViewBG)
        self.view.bringSubviewToFront(self.messagesCollectionView)
    }
    deinit {
        self.messageInputBar.inputTextView.delegate = nil
        
        self.messagesCollectionView.messagesDataSource = nil
        self.messagesCollectionView.messageCellDelegate = nil
        
        self.messagesCollectionView.messagesLayoutDelegate = nil
        self.messagesCollectionView.messagesDisplayDelegate = nil
    }
    @objc open func btnNavBarRightClick() {
        
    }
    private func innerInitData(_ isEnd: Bool = false) {
        
        var time = Date.init().timeIntervalSince1970
        let lasttime = self.arrayMessage.first?.sentDate
        if lasttime == nil {
            self.arrayMessage.removeAll()
        } else {
            time = lasttime!.timeIntervalSince1970
        }
        var models: [ZModelMessage]?
        let receiveId = (self.modelUser?.userid ?? "")
        ZSQLiteKit.getArrayMessage(models: &models, userid: receiveId, time: time)
        if models?.count != 0 {
            let receiveNickname = self.modelUser?.nickname ?? ""
            let receiveHead = self.modelUser?.avatar ?? ""
            let receiveRole = self.modelUser?.role ?? .user
            let receiveGender = self.modelUser?.gender ?? .male
            let receiveUser = ZModelMessageUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole.rawValue, gender: receiveGender.rawValue)
            let senderUser = self.loginUser
            models?.forEach({ (item) in
                let sendTime = Date(timeIntervalSince1970: item.message_time)
                switch item.message_direction {
                case .send:
                    let model = ZModelMessageType.init(text: item.message, sender: senderUser, receive: receiveUser, messageId: item.message_id, sentDate: sendTime)
                    self.arrayMessage.insert(model, at: 0)
                case .receive:
                    let model = ZModelMessageType.init(text: item.message, sender: receiveUser, receive: senderUser, messageId: item.message_id, sentDate: sendTime)
                    self.arrayMessage.insert(model, at: 0)
                default: break
                }
            })
        }
        self.messagesCollectionView.es.stopPullToRefresh(ignoreFooter: true)
        self.messagesCollectionView.reloadData()
    }
    private func innerInitEvent() {
        self.messagesCollectionView.es.addPullToRefresh { [unowned self] in
            self.innerInitData()
        }
        self.btnSend.addTarget(self, action: #selector(btnSendEvent), for: .touchUpInside)
    }
    @objc private func btnSendEvent() {
        let attributedText = self.messageInputBar.inputTextView.attributedText!
        if attributedText.length == 0 {
            self.messageInputBar.inputTextView.becomeFirstResponder()
            return
        }
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            BFLog.info("Autocompleted: \(substring)  with context: \(context ?? [])")
        }
        let components = self.messageInputBar.inputTextView.components
        if components.count == 0 {
            self.messageInputBar.inputTextView.becomeFirstResponder()
            return
        }
        self.messageInputBar.inputTextView.text = ""
        self.messageInputBar.invalidatePlugins()
        DispatchQueue.main.async { [weak self] in
            self?.insertMessages(components)
        }
    }
    /// 发送文本
    open func startSendMessage(_ text: String) {
        // 文本内容不能为空
        guard text.length > 0 && text.length <= self.maxMessageCount else {
            self.messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        BFLog.debug("start send message text: \(text)")
        
        let receiveId = self.modelUser?.userid ?? ""
        let receiveNickname = self.modelUser?.nickname ?? ""
        let receiveHead = self.modelUser?.avatar ?? ""
        let receiveRole = self.modelUser?.role ?? .user
        let receiveGender = self.modelUser?.gender ?? .female
        let receiveUser = ZModelMessageUser.init(senderId: receiveId, displayName: receiveNickname, head: receiveHead, role: receiveRole.rawValue, gender: receiveGender.rawValue)
        let senderUser = self.loginUser
        let sendTime = Date.init()
        
        let messageid = kRandomId
        let message = ZModelMessageType.init(text: text, sender: senderUser, receive: receiveUser, messageId: messageid, sentDate: sendTime)
        self.insertMessage(message)
        self.messageInputBar.inputTextView.text = ""
        self.messageInputBar.invalidatePlugins()
        
        /// 保存消息对象
        let model = ZModelMessage.init()
        model.message_userid = receiveId
        model.message_id = messageid
        model.message = text
        model.message_type = .text
        model.message_time = sendTime.timeIntervalSince1970
        model.message_read_state = true
        ZSQLiteKit.setModel(model: model)
        
        let modelR: ZModelMessageRecord = ZModelMessageRecord()
        modelR.message_user_login = self.modelUser
        modelR.message_id = messageid
        modelR.message = text
        modelR.message_type = .text
        modelR.message_time = model.message_time
        ZSQLiteKit.setModel(model: modelR)
    }
    /// 添加一条消息
    private func insertMessage(_ message: ZModelMessageType) {
        
        self.arrayMessage.append(message)
        // Reload last section to update header/footer labels and insert a new one
        self.messagesCollectionView.performBatchUpdates({
            self.messagesCollectionView.insertSections([self.arrayMessage.count - 1])
            if self.arrayMessage.count >= 2 {
                self.messagesCollectionView.reloadSections([self.arrayMessage.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    /// 处理滑动动画
    final func isLastSectionVisible() -> Bool {
        
        guard !self.arrayMessage.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: self.arrayMessage.count - 1)
        
        return self.messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
}
/// 文本输入框
extension ZMessageViewController: InputBarAccessoryViewDelegate, UITextViewDelegate {
    // 因为用的是自己的按钮。 所以不会走这个方法
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
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                self.startSendMessage(str)
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
        if textLength > self.maxMessageCount {
            return false
        }
        return true
    }
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.length > self.maxMessageCount {
            let text = textView.text ?? ""
            textView.text = String(text[..<text.index(text.startIndex, offsetBy: self.maxMessageCount)])
        }
    }
}
