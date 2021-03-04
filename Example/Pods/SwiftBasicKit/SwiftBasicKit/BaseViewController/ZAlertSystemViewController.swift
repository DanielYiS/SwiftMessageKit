import UIKit

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
        self.view.backgroundColor = UIColor.clear
    }
}
