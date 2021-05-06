import UIKit
import BFKit

public class ZAlertSystemViewController: UIAlertController {
    
    public override var shouldAutorotate: Bool {
        return false
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    public required convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewUI()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ZCurrentVC.shared.currentPresentVC = self
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ZCurrentVC.shared.currentPresentVC = nil
    }
    private func setupViewUI() {
        if #available(iOS 11.0, *) {
            self.edgesForExtendedLayout = UIRectEdge.top
            self.viewRespectsSystemMinimumLayoutMargins = false
        } else {
            self.edgesForExtendedLayout = UIRectEdge.all
            self.automaticallyAdjustsScrollViewInsets = false
        }
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.extendedLayoutIncludesOpaqueBars = false
        self.view.isUserInteractionEnabled = true
        if ZAlertView.shared.useCustomStyle {
            self.visualEffectView?.effect = UIBlurEffect.init(style: self.attributedContentStyle)
            self.view.subviews.first?.backgroundColor = self.attributedBackgroundColor
            self.view.subviews.first?.subviews.first?.backgroundColor = self.attributedBackgroundColor
            self.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = self.attributedBackgroundColor
            self.setViewBGColorChange(view: self.view)
        }
    }
    private func setViewBGColorChange(view: UIView) {
        if view.subviews.count > 0 {
            view.subviews.forEach { (item) in
                if let classname = NSClassFromString("UIVisualEffectView"), item.isMember(of: classname) {
                    item.backgroundColor = self.attributedBackgroundColor
                    item.border(color: .clear, radius: 15, width: 0)
                }
                if let classname = NSClassFromString("_UIVisualEffectBackdropView"), item.isMember(of: classname) {
                    item.backgroundColor = self.attributedBackgroundColor
                    item.border(color: .clear, radius: 15, width: 0)
                }
                if let classname = NSClassFromString("_UIVisualEffectSubview"), item.isMember(of: classname) {
                    item.backgroundColor = self.attributedBackgroundColor
                    item.border(color: .clear, radius: 15, width: 0)
                }
                if let classname = NSClassFromString("_UIVisualEffectContentView"), item.isMember(of: classname) {
                    item.backgroundColor = self.attributedBackgroundColor
                    item.border(color: .clear, radius: 15, width: 0)
                }
                if item.isMember(of: UILabel.classForCoder()) {
                    item.backgroundColor = self.attributedBackgroundColor
                    item.border(color: .clear, radius: 15, width: 0)
                }
                self.setViewBGColorChange(view: item)
            }
        }
    }
    public override func addAction(_ action: UIAlertAction) {
        super .addAction(action)
        if ZAlertView.shared.useCustomStyle {
            switch action.tag {
            case 1000:
                action.setValue(self.attributedCancelColor, forKey: "titleTextColor")
                guard let label = (action.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
                label.superview?.superview?.backgroundColor = self.attributedBackgroundColor
                label.superview?.backgroundColor = self.attributedBackgroundColor
            default:
                action.setValue(self.attributedButtonColor, forKey: "titleTextColor")
                guard let label = (action.value(forKey: "__representer")as? NSObject)?.value(forKey: "label") as? UILabel else { return }
                label.superview?.superview?.backgroundColor = self.attributedBackgroundColor
                label.superview?.backgroundColor = self.attributedBackgroundColor
            }
        }
    }
}
