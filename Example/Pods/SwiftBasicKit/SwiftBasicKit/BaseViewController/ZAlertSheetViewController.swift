
import UIKit
import BFKit

public class ZAlertSheetViewController: ZBaseViewController {

    public var label: String?
    public var message: String?
    public var buttons: [String] = [String]()
    
    public var attributedBackgroundColor = ZAlertView.shared.backgroundColor.color
    public var attributedContentStyle = ZAlertView.shared.attributedContentStyle
    public var attributedButtonColor = ZAlertView.shared.attributedCancelColor.color
    public var attributedCancelColor = ZAlertView.shared.attributedButtonColor.color
    public var attributedTitleColor = ZAlertView.shared.attributedTitleColor.color
    public var attributedMessageColor = ZAlertView.shared.attributedMessageColor.color
    public var attributedLineColor = "#1F1825".color
    
    public var onButtonItemClick: ((_ row: Int) -> Void)?
    
    private lazy var viewBG: UIView = {
        let temp = UIView.init(frame: CGRect.main())
        temp.alpha = 0
        temp.backgroundColor = .black
        return temp
    }()
    private lazy var viewContent: UIView = {
        let temp = UIView.init(frame: CGRect.init(10.scale, kScreenHeight, kScreenWidth - 20.scale, 50.scale * CGFloat(buttons.count)))
        temp.backgroundColor = attributedBackgroundColor
        temp.border(color: .clear, radius: 15, width: 0)
        return temp
    }()
    private lazy var btnCancel: UIButton = {
        let temp = UIButton.init(frame: CGRect.init(10.scale, viewContent.y + viewContent.height + 10.scale, kScreenWidth - 20.scale, 50.scale))
        temp.adjustsImageWhenHighlighted = false
        temp.titleLabel?.fontSize = 18
        temp.setTitle(L10n.btnCancel, for: .normal)
        temp.setTitleColor(attributedCancelColor, for: .normal)
        temp.border(color: .clear, radius: 15, width: 0)
        temp.backgroundColor = attributedBackgroundColor
        return temp
    }()
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.showType = 2
        self.view.backgroundColor = .clear
        self.view.addSubview(self.viewBG)
        self.view.addSubview(self.viewContent)
        self.view.addSubview(self.btnCancel)
        self.view.sendSubviewToBack(self.viewBG)
        
        self.viewBG.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "viewbgtapevent:"))
        self.btnCancel.addTarget(self, action: "btnCancelClick", for: .touchUpInside)
        
        let btnw = self.viewContent.width
        var btny: CGFloat = 0
        for (i, text) in self.buttons.enumerated() {
            let temp = UIButton.init(frame: CGRect.init(0, btny, btnw, 50.scale))
            temp.tag = 10 + i
            temp.backgroundColor = .clear
            temp.adjustsImageWhenHighlighted = false
            temp.setTitle(text, for: .normal)
            temp.setTitleColor(attributedButtonColor, for: .normal)
            temp.titleLabel?.fontSize = 18
            temp.addTarget(self, action: "btnButtonClick:", for: .touchUpInside)
            self.viewContent.addSubview(temp)
            if i < self.buttons.count - 1 {
                let line = UIView.init(frame: CGRect.init(0, btny + temp.height, btnw, 0.5.scale))
                line.backgroundColor = attributedLineColor
                self.viewContent.addSubview(line)
            }
            btny += 50.scale
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ZCurrentVC.shared.currentPresentVC = self
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewContent.y >= kScreenHeight {
            UIView.animate(withDuration: 0.25, animations: {
                self.viewBG.alpha = 0.1
                self.viewContent.y = kScreenHeight - self.viewContent.height - self.btnCancel.height - 15.scale
                self.btnCancel.y = self.viewContent.y + self.viewContent.height + 10.scale
            })
        }
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ZCurrentVC.shared.currentPresentVC = nil
    }
    @objc private func btnButtonClick(_ sender: UIButton) {
        self.onButtonItemClick?(sender.tag - 10)
        self.btnCancelClick()
    }
    @objc private func viewbgtapevent(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: self.btnCancelClick()
        default: break
        }
    }
    @objc private func btnCancelClick() {
        UIView.animate(withDuration: 0.25, animations: {
            self.viewBG.alpha = 0
            self.viewContent.y = kScreenHeight
            self.btnCancel.y = kScreenHeight + self.viewContent.height + 10.scale
        }, completion: { _ in
            ZRouterKit.dismiss(fromVC: self, animated: false, completion: nil)
        })
    }
    
}
