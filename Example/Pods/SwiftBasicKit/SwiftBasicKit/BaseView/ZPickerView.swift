
import UIKit

public class ZPickerView: UIPickerView {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tintColor = "#FFFFFF".color
        self.backgroundColor = "#1F1824".color
        self.setValue("#FFFFFF".color, forKey: "textColor")
    }
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            self.inputView?.backgroundColor = self.backgroundColor
        }
    }
}
