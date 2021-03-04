
import UIKit

public class ZDatePicker: UIDatePicker {

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public required convenience init(frame: CGRect, value: Date) {
        self.init(frame: frame)
        
        self.date = value
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tintColor = UIColor.init(hex: "#EFF2F8")
        self.backgroundColor = UIColor.init(hex: "#EFF2F8")
    }
}
